exports = function(payload) {
  var conn = context.services.get("mongodb-atlas").db("plex").collection("iscomcastdown");
  var obj = {};
  //obj.payload = payload;
  var body = payload.body.text();
  obj = JSON.parse(body);
  obj.clidateparsed = new Date(obj.clidate);
  
  obj.mdb_created = new Date();
  conn.insertOne(obj);
};