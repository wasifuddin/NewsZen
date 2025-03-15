const app = require('./app');
const db = require('./config/db');
const UserModel = require('./model/user.model');
const DataModel = require('./model/data.model');

const port = 3001;

app.get('/',(req,res)=>{
    res.send("Hello World nnn")
});
app.listen(port,"0.0.0.0",()=>{
    console.log('Server listening on Port http:://localhost:3001');
});