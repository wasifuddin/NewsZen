const mongoose = require ('mongoose');
const bcrypt = require('bcrypt');

const db = require('../config/db');

const { Schema } =  mongoose;


const DataSchema = new Schema({
  
    _id:{
        type:mongoose.Schema.Types.ObjectId,
        
    },
    title:{
        type:String,
        required: true,
    },
    content:{
        type:String,
        required: true,
    },
    source:{
        type:String,
        required: true,
    },
    timestamp:{
        type:Date,
        required: true,
    },
    video_urls:{
        type:String,
        required: true,
    },
    image_urls:{
        type:String,
        required: true,
    },
    tag: {
        type: String,
        required: true,
    },
    language:{
        type: String,
        required: true,
    },
    like_count: {
        type:Number,
        required: true,

    },
    priority:{
        type: Number,
        required: true,

    }

},{ collection: 'twitter' });

const DataModel = db.model('twitter',DataSchema);

module.exports = DataModel;