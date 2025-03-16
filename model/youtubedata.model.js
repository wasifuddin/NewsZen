const mongoose = require ('mongoose');
const bcrypt = require('bcrypt');

const db = require('../config/db');

const { Schema } =  mongoose;


const YoutubeDataSchema = new Schema({
  
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
    views:{
        type:Number,
        required:true,
    },
    like_count: {
        type:Number,
        required: true,

    },
    priority:{
        type: Number,
        required: true,

    }

},{ collection: 'youtube_channels' });

const YoutubeDataModel = db.model('youtube_channels',YoutubeDataSchema);

module.exports = YoutubeDataModel;