const router = require('express').Router();
const UserController = require("../controller/user.controller");

router.post('/registration',UserController.register);

router.post('/login',UserController.login);

router.post('/addLiked', UserController.addLikedToUser);

router.post('/addSaved', UserController.addSavedToUser);

router.post('/removeLiked', UserController.removeLikeFromUser);

router.post('/removeSaved', UserController.removeSaveFromUser);

router.post('/getpriorities', UserController.getPriorities);

router.post('/getsavednews', UserController.getSavedNews);

module.exports= router;