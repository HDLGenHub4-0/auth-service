import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;

mysql:Client dbClient = check new (
    host = "localhost",
    port = 3306,
    database = "ballerina_db",
    user = "ballerina_user",
    password = "ballerina_pass"
);

service on new http:Listener(8080) {
    resource function get hello() returns string {
        return "Hello, World!";
    }

    // GET /users - fetch all users from MySQL
    resource function get users() returns json[]|error {
        sql:ParameterizedQuery query = `SELECT id, username, email, created_at FROM users`;
        stream<record {}, error?> resultStream = dbClient->query(query);
        
        json[] users = [];
        check from record {} user in resultStream
            do {
                users.push(user.toJson());
            };
        
        return users;
    }
}