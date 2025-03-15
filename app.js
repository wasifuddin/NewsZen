const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('./routes/user.route');
const dataRouter = require('./routes/data.route');

const app = express();

app.use(body_parser.json());

app.use('/',userRouter);
app.use('/',dataRouter);




module.exports = app;