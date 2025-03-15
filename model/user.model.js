const mongoose = require ('mongoose');
const bcrypt = require('bcrypt');

const db = require('../config/db');

const { Schema } =  mongoose;

const userSchema = new Schema({
    email:{
        type:String,
        lowercase:true,
        required:true,
        unique:true,
    },

    password:{
        type:String,
        required:true,

    },
    username:{
        type:String,
        required:true,
    },
    liked: {
        type: [String], // Array of strings
        default: [],  // Can be null initially
    },
    saved: {
        type: [String], // Array of strings
        default: [],  // Can be null initially
    },
    categoryPriority: {
        type: Map,
        of: Number, // Storing priority as numbers
        default: {
            world: 0,
            sports: 0,
            technology: 0,
            politics: 0,
            finance: 0,
            business: 0,
            national: 0,
            entertainment: 0,
        },
    },
    sourcePriority: {
        type: Map,
        of: Number, // Storing priority as numbers
        default: {
    
            "bdnews24": 0,
            "mzamin": 0,
            "The Daily Star": 0,
            "The Daily Ittefaq": 0,
            "CNN": 0,
            "Al Zazeera": 0,
    
        },
    }


});

userSchema.pre('save',async function(){
    try {
        var user = this;
        const salt = await(bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password,salt);
        user.password= hashpass;
    } catch (error) {
        throw error;
    }

});

userSchema.methods.comparePassword = async function (userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword,this.password);
        return isMatch;
    } catch (error) {
        throw(error);
    }
}

const UserModel = db.model('user',userSchema);

module.exports = UserModel;