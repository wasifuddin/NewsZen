const UserModel = require('../model/user.model')
const jwt = require('jsonwebtoken');

class UserService{
    static async registerUser(email,password,username){
       try {
        const createUser = new UserModel({
            email,
            password,
            username
        });
        ;
        return await createUser.save();
        
       } catch (error) {
        if (error.code === 11000) {
            return { error: 'Duplicate email: This email is already registered.' };
        }
        throw error;
       } 
    }

    static async checkuser(email)
    {
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData,secretKey,jwt_expire)
    {
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire});
    }
    static async addLikedToUser(email, newsId , category , source) {
        try {
            const updatedUser = await UserModel.findOneAndUpdate(
                { email },
                { $push: { liked: newsId },
                $inc: { 
                    [`categoryPriority.${category}`]: 1, // Increase category priority
                    [`sourcePriority.${source}`]: 1 // Increase source priority
                }
                }, // Push new string to array
                { new: true , upsert: false} // Return updated document
            );

            return updatedUser;
        } catch (error) {
            throw error;
        }
    }
    static async addSavedToUser(email, newsId,category, source ) {
        try {
            const updatedUser = await UserModel.findOneAndUpdate(
                { email },
                { $push: { saved: newsId } ,
                $inc: { 
                    [`categoryPriority.${category}`]: 2, // Increase category priority (higher than liked)
                    [`sourcePriority.${source}`]: 2 // Increase source priority (higher than liked)
                }
                }, // Push new string to array
                { new: true } // Return updated document
            );

            return updatedUser;
        } catch (error) {
            throw error;
        }
    }
    static async removeLikeFromUser(email, newsId, category, source) {
        try {
            // Find the user and remove the specific string from the array
            const user = await UserModel.findOneAndUpdate(
                { email },
                { $pull: { liked: newsId } ,
                $inc: { 
                    [`categoryPriority.${category}`]: -1, // Decrease category priority
                    [`sourcePriority.${source}`]: -1 // Decrease source priority
                }
                }, // MongoDB `$pull` operator removes the value from the array
                { new: true , upsert: false} // Return the updated user object
            );
    
            if (!user) {
                return { error: 'User not found or string not found in the array' };
            }
    
            return user; // Return the updated user object
        } catch (error) {
            throw error;
        }
    }
    static async removeSaveFromUser(email, newsId, category, source) {
        try {
            // Find the user and remove the specific string from the array
            const user = await UserModel.findOneAndUpdate(
                { email },
                { $pull: { saved: newsId } ,
                $inc: { 
                    [`categoryPriority.${category}`]: -2, // Decrease category priority (saved had higher weight)
                    [`sourcePriority.${source}`]: -2 // Decrease source priority (saved had higher weight)
                }
                }, // MongoDB `$pull` operator removes the value from the array
                { new: true , upsert: false } // Return the updated user object
            );
    
            if (!user) {
                return { error: 'User not found or string not found in the array' };
            }
    
            return user; // Return the updated user object
        } catch (error) {
            throw error;
        }
    }
    static async getUserByEmail(email)
    {
        try {
            const user = await UserModel.findOne({ email });
            return user;
        } catch (error) {
            throw error;
        }
    }
    static async getSavedNews(email)
    {
        try {
            const user = await UserModel.findOne({ email });
    
            if (!user || !user.saved || user.saved.length === 0) {
                return null; // No saved news found
            }
    
            return user.saved; // Return the array of saved news IDs
        } catch (error) {
            throw error;
        }
    }
    
    

}


module.exports = UserService;