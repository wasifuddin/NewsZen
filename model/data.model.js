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
    imageurl:{
        type:String,
        required: true,
    },
    source:{
        type:String,
        required: true,
    },
    url:{
        type:String,
        required: true,
    },
    dateTime:{
        type:Date,
        required: true,
    },
    description:{
        type:String,
        required: true,
    }, topic: {
        type: String,
        required: true,
    },
    likecount: {
        type:Number,
        required: true,

    },
    
    language:{
        type: String,
        required: true,

    },
    priority:{
        type: Number,
        required: true,

    }

},{ collection: 'news' });

const DataModel = db.model('news',DataSchema);

module.exports = DataModel;