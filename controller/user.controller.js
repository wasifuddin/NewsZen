const UserService = require('../services/user.services');

exports.register = async (req,res,next)=>{
    try {
        const{email,password,username} = req.body;
        const result = await UserService.registerUser(email,password,username);
        if (result.error) {
            // Respond with the duplicate email error
            return res.status(400).json({ error: result.error });
        }
        res.json({status:true,success:"User Registration Successful"});
    } catch (error) {
        
            res.status(500).json({ error: 'An internal server error occurred' });
        
        throw error;
    }
}

exports.login = async (req,res,next)=>{
    try {
        const{email,password} = req.body;

        const user =await UserService.checkuser(email);

        if(!user)
        {
            return res.status(404).json({ error: 'Invalid User' });
        }

        const isMatch =await user.comparePassword(password);
        if(isMatch == false )
        {
            return res.status(401).json({ error: 'Password Incorrect' });
        }

        let tokenData = {_id:user._id,email:user.email,username:user.username};

       
        const token = await UserService.generateToken(tokenData,'secretKey','1h');

        res.status(200).json({status:true,token:token});
    } catch (error) {
        
            res.status(500).json({ error: 'An internal server error occurred' });
        
        throw error;
    }
}

exports.addLikedToUser = async (req, res, next) => {
    try {
        const { email, newsId, category, source} = req.body;

        if (!email || !newsId || !category || !source) {
            return res.status(400).json({ error: "Email and newString are required." });
        }

        const updatedUser = await UserService.addLikedToUser(email, newsId, category, source);

        if (!updatedUser) {
            return res.status(404).json({ error: "User not found" });
        }

        res.status(200).json({ status: true, message: "String added successfully", updatedUser });
    } catch (error) {
        res.status(500).json({ error: 'An internal server error occurred' });
        throw error;
    }
};

exports.addSavedToUser = async (req, res, next) => {
    try {
        const { email, newsId, category, source } = req.body;

        if (!email || !newsId || !category || !source) {
            return res.status(400).json({ error: "Email and newString are required." });
        }

        const updatedUser = await UserService.addSavedToUser(email, newsId, category, source);

        if (!updatedUser) {
            return res.status(404).json({ error: "User not found" });
        }

        res.status(200).json({ status: true, message: "String added successfully", updatedUser });
    } catch (error) {
        res.status(500).json({ error: 'An internal server error occurred' });
        throw error;
    }
};

exports.removeLikeFromUser = async (req, res, next) => {
    try {
        const { email, newsId, category, source} = req.body; // Get email and string to remove from the request body

        if (!email || !newsId || !category || !source) {
            return res.status(400).json({ error: "Email and string to remove are required" });
        }

        const result = await UserService.removeLikeFromUser(email, newsId, category, source);

        if (result.error) {
            return res.status(400).json({ error: result.error });
        }

        res.status(200).json({ status: true, message: "String removed successfully" });
    } catch (error) {
        res.status(500).json({ error: "An internal server error occurred" });
        throw error;
    }
};

exports.removeSaveFromUser = async (req, res, next) => {
    try {
        const { email, newsId, category, source } = req.body; // Get email and string to remove from the request body

        if (!email || !newsId || !category || !source) {
            return res.status(400).json({ error: "Email and string to remove are required" });
        }

        const result = await UserService.removeSaveFromUser(email, newsId, category, source);

        if (result.error) {
            return res.status(400).json({ error: result.error });
        }

        res.status(200).json({ status: true, message: "String removed successfully" });
    } catch (error) {
        res.status(500).json({ error: "An internal server error occurred" });
        throw error;
    }
};

exports.getPriorities = async (req, res, next) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ error: "Email is required" });
        }

        // Call the UserService to fetch user by email
        const user = await UserService.getUserByEmail(email);

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        // Send back categoryPriority and sourcePriority
        res.status(200).json({
            status: true,
            categoryPriority: user.categoryPriority,
            sourcePriority: user.sourcePriority
        });
    } catch (error) {
        res.status(500).json({ error: 'An internal server error occurred' });
        throw error;
    }
};

exports.getSavedNews = async (req, res, next) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({ error: "Email is required to fetch saved news." });
        }

        const savedNews = await UserService.getSavedNews(email);

        if (!savedNews) {
            return res.status(404).json({ error: "User not found or no saved news available." });
        }

        res.status(200).json({ status: true, savedNews });
    } catch (error) {
        res.status(500).json({ error: "An internal server error occurred" });
        throw error;
    }
};

