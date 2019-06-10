const mysql = require("mysql");
const MYSQL_CONFIG = require("../config/mysql_config");

//mysql
const pool = mysql.createPool(MYSQL_CONFIG);

//query查询语句
const query = (sql,val) => {
    return new Promise((resolve,reject) => {
        pool.getConnection(function(err, connection){
            if(err) {
                reject(err);
            } else {
                connection.query(sql, val, (err,fields) => {
                    if(err) {
                        return reject(err);
                    } else {
                        resolve(fields);
                        connection.release();
                    }
                });
            }
        });
    });
}



module.exports = {
    query
};