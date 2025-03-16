// controllers/data.controller.js
const dataService = require('../services/data.services');

class DataController {
    // Handle the API endpoint to get data
    async getData(req, res) {
        try {
            const page = parseInt(req.query.page) || 1;
            const data = await dataService.getData(page);
            
            res.json(data.map(doc => ({
                id: doc._id.toString(),
                title: doc.title,
                imageurl: doc.imageurl,
                source: doc.source,
                url: doc.url,
                dateTime: doc.dateTime,
                description: doc.description,
                topic: doc.topic,
                language: doc.language,
                likecount: doc.likecount,
                priority: doc.priority
            })));
        } catch (err) {
            res.status(500).send('Error fetching data: ' + err.message);
        }
    }
    
       
    
    async searchData(req, res) {
    try {
        const searchString = req.query.q;
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10; // Default limit = 10
        
        if (!searchString) {
            return res.status(400).json({ error: "Query parameter 'q' is required." });
        }

        const data = await dataService.searchData(searchString, page, limit);

        res.json({
            currentPage: page,
            totalResults: data.length,
            results: data.map(doc => ({
                id: doc._id.toString(),
                title: doc.title,
                imageurl: doc.imageurl,
                source: doc.source,
                url: doc.url,
                dateTime: doc.dateTime,
                description: doc.description,
                topic: doc.topic,
                language: doc.language,
                likecount: doc.likecount,
                priority: doc.priority
            }))
        });
    } catch (err) {
        res.status(500).send('Error searching data: ' + err.message);
    }
}

async getMostViewed(req, res) {
    try {
        const page = parseInt(req.query.page) || 1;
        const data = await dataService.getMostViewed(page);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority,
            views: doc.views  // computed field
        })));
    } catch (err) {
        res.status(500).send('Error fetching most viewed data: ' + err.message);
    }
}

async getTrending(req, res) {
    try {
        const page = parseInt(req.query.page) || 1;
        const data = await dataService.getTrending(page);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority,
           
        })));
    } catch (err) {
        res.status(500).send('Error fetching trending news: ' + err.message);
    }
}

async getPopular(req, res) {
    try {
        const page = parseInt(req.query.page) || 1;
        const data = await dataService.getPopular(page);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority,
            popularScore: doc.popularScore
        })));
    } catch (err) {
        res.status(500).send('Error fetching popular news: ' + err.message);
    }
}
async getLatest(req, res) {
    try {
        const page = parseInt(req.query.page) || 1;
        const data = await dataService.getLatest(page);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority
        })));
    } catch (err) {
        res.status(500).send('Error fetching latest news: ' + err.message);
    }
}
async getRecommendedNews(req, res) {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        // Expecting the client to send categoryPriority and sourcePriority in the body.
        const categoryPriority = req.body.categoryPriority || {};
        const sourcePriority = req.body.sourcePriority || {};

        const data = await dataService.getRecommendedNews(page, limit, categoryPriority, sourcePriority);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority,
            recommendationScore: doc.recommendationScore
        })));
    } catch (err) {
        res.status(500).send('Error fetching recommended news: ' + err.message);
    }
}
async getDataByCategory(req, res) {
    try {
        const category = req.query.category;
        if (!category) {
            return res.status(400).json({ error: "Category query parameter is required." });
        }
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const data = await dataService.getDataByCategory(category, page, limit);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority
        })));
    } catch (err) {
        res.status(500).send('Error fetching data: ' + err.message);
    }
}
async getDataBySource(req, res) {
    try {
        const source = req.query.source;
        if (!source) {
            return res.status(400).json({ error: "Source query parameter is required." });
        }
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const data = await dataService.getDataBySource(source, page, limit);
        
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurl: doc.imageurl,
            source: doc.source,
            url: doc.url,
            dateTime: doc.dateTime,
            description: doc.description,
            topic: doc.topic,
            language: doc.language,
            likecount: doc.likecount,
            priority: doc.priority
        })));
    } catch (err) {
        res.status(500).send('Error fetching data by source: ' + err.message);
    }
}

async getNewsById(req, res) {
    try {
        const { id } = req.body; // Extract ID from request body
        if (!id) {
            return res.status(400).json({ error: "News ID is required" });
        }

        const news = await dataService.getNewsById(id);

        res.json({
            id: news._id.toString(),
            title: news.title,
            imageurl: news.imageurl,
            source: news.source,
            url: news.url,
            dateTime: news.dateTime,
            description: news.description,
            topic: news.topic,
            language: news.language,
            likecount: news.likecount,
            priority: news.priority
        });
    } catch (err) {
        res.status(500).json({ error: "Error fetching news: " + err.message });
    }
}

// for twitter

async getTwitterData(req, res) {

    try {
        const page = parseInt(req.query.page) || 1;  // Get page number from query params (default is 1)
        const data = await dataService.getTwitterData(page); // Fetch data using the service
        
        console.log("data successfully reached controller");
        console.log(data);

        const likecount = parseInt(data.likecount) || 0;
        // Base calculations

        // Map the data and send as response
        res.json(data.map(doc => ({
            id: doc._id.toString(),
            title: doc.title,
            imageurls: doc.image_urls,
            videourls: doc.video_urls,
            source: doc.source,
            dateTime: doc.timestamp,
            description: doc.content,
            topic: doc.tag,
            language: doc.language,
            likecount: doc.like_count,
            priority:doc.priority,
        })));
    } catch (err) {
        res.status(500).send('Error fetching data: ' + err.message);
    }
    }

    // the endpoint will be /search?q=wordtosearch
    async searchTwitterData(req, res) {
        try {
            const searchString = req.query.q;
            const page = parseInt(req.query.page) || 1;
            const limit = parseInt(req.query.limit) || 10; // Default limit = 10
            
            if (!searchString) {
                return res.status(400).json({ error: "Query parameter 'q' is required." });
            }
    
            const data = await dataService.searchTwitterData(searchString, page, limit);
            
            console.log("found data is " + data);
            res.json({
                currentPage: page,
                totalResults: data.length,
                results: data.map(doc => ({
                    id: doc._id.toString(),
                    title: doc.title,
                    imageurls: doc.image_urls,
                    videourls: doc.video_urls,
                    source: doc.source,
                    dateTime: doc.timestamp,
                    description: doc.content,
                    topic: doc.tag,
                    language: doc.language,
                    likecount: doc.like_count,
                    priority:doc.priority,
                }))
            });
        } catch (err) {
            res.status(500).send('Error searching data: ' + err.message);
        }
        }

        async TwittergetMostViewed(req, res) {
            try {
                const page = parseInt(req.query.page) || 1;
                const data = await dataService.TwittergetMostViewed(page);
                
                res.json(data.map(doc => ({
                    id: doc._id.toString(),
                    title: doc.title,
                    imageurls: doc.image_urls,
                    videourls: doc.video_urls,
                    source: doc.source,
                    dateTime: doc.timestamp,
                    description: doc.content,
                    topic: doc.tag,
                    language: doc.language,
                    likecount: doc.like_count,
                    priority:doc.priority,
                    views: doc.views  // computed field
                })));
            } catch (err) {
                res.status(500).send('Error fetching most viewed data: ' + err.message);
            }
        }



}


module.exports = new DataController();
