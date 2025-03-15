const mongoose = require ('mongoose');


const connection = mongoose.createConnection('mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/mydatabase?retryWrites=true&w=majority&appName=Newszen&serverSelectionTimeoutMS=30000', {
   
}).on('open',()=>{
    console.log("MongoDB Connected");
}).on('error',()=>{
    console.log("Error");
});




module.exports = connection;

