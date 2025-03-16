// services/data.service.js
const TwitterDataModel = require('../model/twitterdata.model');
const YoutubeDataModel = require('../model/youtubedata.model');


const DataModel = require('../model/data.model');
const twittertopics = [ "Cricket", "Bangladesh", "Palestine", "Islam", "Football", "Technology", "World" ];
const youtubetopics = [ "Bengaladesh", "International"];

class DataService {
        async getData(page = 1) {
            try {
                // Define your news types array
                const newsTypes = ['national', 'world', 'politics', 'sports', 'business', 'finance', 'technology', 'entertainment'];
                
                // 1. For the current page, fetch up to 2 items per topic.
                let guaranteedItems = [];
                for (const type of newsTypes) {
                    const items = await DataModel.find({ topic: type })
                        .sort({ dateTime: -1 })
                        .skip((page - 1) * 2)  // paginate per topic: page 1 gets first 2, page 2 gets next 2, etc.
                        .limit(2);
                    guaranteedItems.push(...items);
                }
                const guaranteedCount = guaranteedItems.length; // may be less than 16 if some topics are short
                
                // 2. Compute a reserved set of items: these are the items that would have been used in previous pages
                //    for each topic (so we don’t repeat them in additional fill).
                let reservedIDs = [];
                for (const type of newsTypes) {
                    const reserved = await DataModel.find({ topic: type })
                        .sort({ dateTime: -1 })
                        .limit((page - 1) * 2); // all items allocated to previous pages for this topic
                    reservedIDs.push(...reserved.map(doc => doc._id));
                }
                // Also reserve the items already chosen for the current page
                reservedIDs.push(...guaranteedItems.map(doc => doc._id));
                
                // 3. Calculate how many additional items are needed to reach 16.
                const missingCount = 16 - guaranteedCount;
                let additionalItems = [];
                if (missingCount > 0) {
                    // Here we fill from the overall collection (sorted by dateTime descending)
                    // while excluding any items already reserved.
                    // We also paginate additional items by skipping additional items allocated to earlier pages.
                    additionalItems = await DataModel.find({ _id: { $nin: reservedIDs } })
                        .sort({ dateTime: -1 })
                        .skip((page - 1) * missingCount) // simple pagination for additional items
                        .limit(missingCount);
                }
                
                // 4. Combine and (optionally) sort the final results.
                let results = [...guaranteedItems, ...additionalItems];
                results.sort((a, b) => b.dateTime - a.dateTime);
                
                // Ensure exactly 16 items are returned.
                return results.slice(0, 16);
            } catch (error) {
                throw new Error('Error fetching data: ' + error.message);
            }
        }
        

    async searchData(searchString, page = 1, limit = 10) {
        try {
            return await DataModel.find({
                title: { $regex: searchString, $options: 'i' }
            })
            .skip((page - 1) * limit)
            .limit(limit);
        } catch (error) {
            throw new Error('Error searching data: ' + error.message);
        }
    }
    
    async getMostViewed(page = 1, limit = 10) {
        try {
            const pipeline = [
                // Compute the views field: likecount * 110
                {
                    $addFields: {
                        views: { $multiply: ["$likecount", 110] }
                    }
                },
                // Sort by computed views (desc) and then by dateTime (desc) as secondary order
                { $sort: { views: -1, dateTime: -1 } },
                // Skip to the proper page
                { $skip: (page - 1) * limit },
                // Limit to the desired number of documents
                { $limit: limit }
            ];
            const data = await DataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching most viewed data: ' + error.message);
        }
    }
    async getTrending(page = 1, limit = 10) {
        try {
            const pipeline = [
                // Calculate the hours since publication using the current date (using $$NOW)
                {
                    $addFields: {
                        hoursAgo: {
                            $divide: [
                                { $subtract: ["$$NOW", { $toDate: "$dateTime" }]
                            },
                                1000 * 60 * 60
                            ]
                        }
                    }
                },
                // Calculate the trending score: (likecount * 110) / (hoursAgo + 2)
                {
                    $addFields: {
                        trendingScore: {
                            $divide: [
                                { $multiply: ["$likecount", 110] },
                                { $add: ["$hoursAgo", 2] }
                            ]
                        }
                    }
                },
                // Sort by trendingScore descending; for tie-breaking, sort by dateTime descending
                { $sort: { trendingScore: -1, dateTime: -1 } },
                // Skip and limit for pagination
                { $skip: (page - 1) * limit },
                { $limit: limit }
            ];
            
            const data = await DataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching trending data: ' + error.message);
        }
    }
    
    async getPopular(page = 1, limit = 10) {
        try {
            const pipeline = [
                // Compute a random multiplier and the resulting popularScore
                {
                    $addFields: {
                        popularScore: {
                            $multiply: [
                                "$likecount",
                                { $add: [0.5, { $rand: {} }] }  // Multiplier between 0.5 and 1.5
                            ]
                        }
                    }
                },
                // Sort by popularScore in descending order; use dateTime as a tie-breaker
                { $sort: { popularScore: -1, dateTime: -1 } },
                // Skip and limit for pagination
                { $skip: (page - 1) * limit },
                { $limit: limit }
            ];
            const data = await DataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching popular data: ' + error.message);
        }
    }

    async getLatest(page = 1, limit = 10) {
        try {
            const latestNews = await DataModel.find()
                .sort({ dateTime: -1 }) // Most recent news first
                .skip((page - 1) * limit)
                .limit(limit);
            return latestNews;
        } catch (error) {
            throw new Error('Error fetching latest news: ' + error.message);
        }
    }
    
    async getRecommendedNews(page = 1, limit = 10, categoryPriority = {}, sourcePriority = {}) {
        try {
            const pipeline = [
                // Use $getField to look up the priority values based on the document's topic and source.
                // We embed the client maps as literal values.
                {
                    $addFields: {
                        categoryScore: {
                            $getField: {
                                field: "$topic",
                                input: { $literal: categoryPriority }
                            }
                        },
                        sourceScore: {
                            $getField: {
                                field: "$source",
                                input: { $literal: sourcePriority }
                            }
                        }
                    }
                },
                // Compute the recommendation score as the sum of the category and source scores.
                {
                    $addFields: {
                        recommendationScore: {
                            $add: [
                                { $ifNull: ["$categoryScore", 0] },
                                { $ifNull: ["$sourceScore", 0] }
                            ]
                        }
                    }
                },
                // Sort by recommendationScore (desc) and use dateTime descending as tie-breaker.
                { $sort: { recommendationScore: -1, dateTime: -1 } },
                // Apply pagination.
                { $skip: (page - 1) * limit },
                { $limit: limit }
            ];
            const data = await DataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching recommended news: ' + error.message);
        }
    }

    async getDataByCategory(category, page = 1, limit = 10) {
        try {
            const data = await DataModel.find({ topic: category })
                .sort({ dateTime: -1 })
                .skip((page - 1) * limit)
                .limit(limit);
            return data;
        } catch (error) {
            throw new Error('Error fetching data by category: ' + error.message);
        }
    }
    
    async getDataBySource(source, page = 1, limit = 10) {
        try {
            const data = await DataModel.find({ source: source })
                .sort({ dateTime: -1 })
                .skip((page - 1) * limit)
                .limit(limit);
            return data;
        } catch (error) {
            throw new Error('Error fetching data by source: ' + error.message);
        }
    }
    
    async getNewsById(newsId) {
        try {
            const news = await DataModel.findById(newsId);
            if (!news) {
                throw new Error("News article not found");
            }
            return news;
        } catch (error) {
            throw new Error("Error fetching news by ID: " + error.message);
        }
    }


    
   //twitter
    
    async getTwitterData(page = 1) {
        try {
            // Define your news types array
            const newsTypes = twittertopics;
            
            // 1. For the current page, fetch up to 2 items per topic.
            let guaranteedItems = [];
            for (const type of newsTypes) {
                const items = await TwitterDataModel.find({ topic: type })
                    .sort({ dateTime: -1 })
                    .skip((page - 1) * 2)  // paginate per topic: page 1 gets first 2, page 2 gets next 2, etc.
                    .limit(2);
                guaranteedItems.push(...items);
            }
            const guaranteedCount = guaranteedItems.length; // may be less than 16 if some topics are short
            
            // 2. Compute a reserved set of items: these are the items that would have been used in previous pages
            //    for each topic (so we don’t repeat them in additional fill).
            let reservedIDs = [];
            for (const type of newsTypes) {
                const reserved = await TwitterDataModel.find({ topic: type })
                    .sort({ dateTime: -1 })
                    .limit((page - 1) * 2); // all items allocated to previous pages for this topic
                reservedIDs.push(...reserved.map(doc => doc._id));
            }
            // Also reserve the items already chosen for the current page
            reservedIDs.push(...guaranteedItems.map(doc => doc._id));
            
            // 3. Calculate how many additional items are needed to reach 16.
            const missingCount = 16 - guaranteedCount;
            let additionalItems = [];
            if (missingCount > 0) {
                // Here we fill from the overall collection (sorted by dateTime descending)
                // while excluding any items already reserved.
                // We also paginate additional items by skipping additional items allocated to earlier pages.
                additionalItems = await TwitterDataModel.find({ _id: { $nin: reservedIDs } })
                    .sort({ dateTime: -1 })
                    .skip((page - 1) * missingCount) // simple pagination for additional items
                    .limit(missingCount);
            }
            
            // 4. Combine and (optionally) sort the final results.
            let results = [...guaranteedItems, ...additionalItems];
            results.sort((a, b) => b.dateTime - a.dateTime);
            // console.log(results);
            
            // Ensure exactly 16 items are returned.
            return results.slice(0, 16);
        } catch (error) {
            throw new Error('Error fetching data: ' + error.message);
        }
    }
    
    
    async searchTwitterData(searchString, page = 1, limit = 10) {
        try {
            return await TwitterDataModel.find({
                content: { $regex: searchString, $options: 'i' }
            })
            .skip((page - 1) * limit)
            .limit(limit);
        } catch (error) {
            throw new Error('Error searching data: ' + error.message);
        }
    }


    async TwittergetMostViewed(page = 1, limit = 10) {
        try {
            const pipeline = [
                // Compute the views field: likecount * 110
                {
                    $addFields: {
                        views: { $multiply: ["$likecount", 110] } // adding a new field, views
                    }
                },
                // Sort by computed views (desc) and then by dateTime (desc) as secondary order
                { $sort: { views: -1, dateTime: -1 } },
                // Skip to the proper page
                { $skip: (page - 1) * limit },
                // Limit to the desired number of documents
                { $limit: limit }
            ];
            const data = await TwitterDataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching most viewed data: ' + error.message);
        }
    }

    
    async getYoutubeData(page = 1) {
        try {
            // Define your news types array
            const newsTypes = youtubetopics;
            
            // 1. For the current page, fetch up to 2 items per topic.
            let guaranteedItems = [];
            for (const type of newsTypes) {
                const items = await YoutubeDataModel.find({ topic: type })
                    .sort({ dateTime: -1 })
                    .skip((page - 1) * 2)  // paginate per topic: page 1 gets first 2, page 2 gets next 2, etc.
                    .limit(2);
                guaranteedItems.push(...items);
            }
            const guaranteedCount = guaranteedItems.length; // may be less than 16 if some topics are short
            
            // 2. Compute a reserved set of items: these are the items that would have been used in previous pages
            //    for each topic (so we don’t repeat them in additional fill).
            let reservedIDs = [];
            for (const type of newsTypes) {
                const reserved = await YoutubeDataModel.find({ topic: type })
                    .sort({ dateTime: -1 })
                    .limit((page - 1) * 2); // all items allocated to previous pages for this topic
                reservedIDs.push(...reserved.map(doc => doc._id));
            }
            // Also reserve the items already chosen for the current page
            reservedIDs.push(...guaranteedItems.map(doc => doc._id));
            
            // 3. Calculate how many additional items are needed to reach 16.
            const missingCount = 16 - guaranteedCount;
            let additionalItems = [];
            if (missingCount > 0) {
                // Here we fill from the overall collection (sorted by dateTime descending)
                // while excluding any items already reserved.
                // We also paginate additional items by skipping additional items allocated to earlier pages.
                additionalItems = await YoutubeDataModel.find({ _id: { $nin: reservedIDs } })
                    .sort({ dateTime: -1 })
                    .skip((page - 1) * missingCount) // simple pagination for additional items
                    .limit(missingCount);
            }
            
            // 4. Combine and (optionally) sort the final results.
            let results = [...guaranteedItems, ...additionalItems];
            results.sort((a, b) => b.dateTime - a.dateTime);
            // console.log(results);
            
            // Ensure exactly 16 items are returned.
            return results.slice(0, 16);
        } catch (error) {
            throw new Error('Error fetching data: ' + error.message);
        }
    }
    
    
    async searchYoutubeData(searchString, page = 1, limit = 10) {
        try {
            return await YoutubeDataModel.find({
                title: { $regex: searchString, $options: 'i' }
            })
            .skip((page - 1) * limit)
            .limit(limit);
        } catch (error) {
            throw new Error('Error searching data: ' + error.message);
        }
    }


    async YoutubegetMostViewed(page = 1, limit = 10) {
        try {
            const pipeline = [
                // Compute the views field: likecount * 110
                {
                    $addFields: {
                        views: { $multiply: ["$likecount", 110] } // adding a new field, views
                    }
                },
                // Sort by computed views (desc) and then by dateTime (desc) as secondary order
                { $sort: { views: -1, dateTime: -1 } },
                // Skip to the proper page
                { $skip: (page - 1) * limit },
                // Limit to the desired number of documents
                { $limit: limit }
            ];
            const data = await YoutubeDataModel.aggregate(pipeline);
            return data;
        } catch (error) {
            throw new Error('Error fetching most viewed data: ' + error.message);
        }
    }
}

module.exports =  new DataService();