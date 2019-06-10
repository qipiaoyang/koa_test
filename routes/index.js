var router = require('koa-router')();
var query = require("../util/query").query;

router.get('/', function *(next) {
  const getUserInfo = yield query('SELECT * FROM `admin_user` WHERE `phone` = "13886441638" AND `password` = "123456" ');
  const getUserInfos = yield query('SELECT * FROM `admin_user`');
  console.log(getUserInfo,"getUserInfos")
  yield this.render('index', {
    title: 'Hello World Koa1!',
    userinfo: getUserInfos
  });
});

router.get('/foo', function *(next) {
  yield this.render('index', {
    title: 'Hello World foo!'
  });
});

module.exports = router;
