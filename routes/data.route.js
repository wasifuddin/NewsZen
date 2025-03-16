const router = require('express').Router();

const dataController = require("../controller/data.controller");

router.get('/data', dataController.getData);
router.get('/search', dataController.searchData);
router.get('/most-viewed', dataController.getMostViewed);
router.get('/trending', dataController.getTrending);
router.get('/popular', dataController.getPopular);
router.get('/latest', dataController.getLatest);
router.post('/recommended', dataController.getRecommendedNews);
router.get('/category', dataController.getDataByCategory);
router.get('/source', dataController.getDataBySource);
router.post('/news', dataController.getNewsById);

//twitter
router.get('/data/twitter', dataController.getTwitterData);
router.get('/search/twitter',dataController.searchTwitterData);
router.get('/most-viewed/twitter', dataController.TwittergetMostViewed);

module.exports= router;