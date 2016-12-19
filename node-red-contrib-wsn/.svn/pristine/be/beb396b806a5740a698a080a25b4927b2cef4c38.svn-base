
var apiVer = 0; // 1: RESTful API, 0: C API

// WSN API Service 
var serverIP = 'advigw-api-gw';
var serverPort = 3000;



// GW Prefix
var gwPrefixPath = 'restapi/WSNManage/Connectivity/';

// SenHub Prefix
var senHubPrefixPath = 'restapi/WSNManage/SenHub/';

var http = require('http');


// Backward Compabile 
var exec = require('child_process').exec;
var API_PROGRAM = "/usr/bin/apimuxcli";
var API_CMD = "";
var API_RESTAPI = "";
var JSON_START_OFFSET = 3;
var JSON_START_KEYWORD = "StatusCode";
var JSON_END_KEYWORD = "eoj";

var fs = require('fs');

function fileExists(filePath)
{
    if (fs.existsSync(filePath))
    {
     console.log('find file '+filePath);
     return 1;
    }
    else
    {
      console.log('can not find '+filePath);
      return 0;
    }
}


function checkWSNAPIVersion()
{
   if( fileExists(API_PROGRAM) == 1 )
      apiVer = 0;
   else
      apiVer = 1;
}

checkWSNAPIVersion(API_PROGRAM);

function VerifyConsoleOutput(error, stdout, stderr, outData ) {
        var JsonObj = null;
        // do basic result check
        var ErrorString = '{"StatusCode":500,"Result":{"sv":"WSN Service is not available"}}';
        if (error) {            
            outData.ret = ErrorString; 
            //console.log("REST exec error: " + error);
            //ErrorStr = "REST exec error: " + error;
            return false;
        }
        
        if (!stdout) {
            //console.log("REST no result");
            //ErrorStr = "REST no result";
             outData.ret = ErrorString; 
            return false;
        }
        //console.log("REST result: " + stdout);
        
        // get json part in result output
        var JsonStartIndex = stdout.indexOf(JSON_START_KEYWORD) - JSON_START_OFFSET;
        var JsonEndIndex = stdout.lastIndexOf(JSON_END_KEYWORD);
        if (JsonStartIndex < 0 || JsonEndIndex < 0) {
            //console.log("Not correct Json result:" + stdout);
            //ErrorStr = "Not correct Json result";
            outData.ret = ErrorString; 
            return false;
        }
        var ResultJsonStr = stdout.substring(JsonStartIndex, JsonEndIndex);
        //console.log("WSN_GwGetX: JSON str:" + ResultJsonStr);
        
    	try {
            JsonObj = JSON.parse(ResultJsonStr);
        } catch (e) {
            //console.log("Json Result parse error: " + e);
            //ErrorStr = "Json Result parse error: " + e;
            outData.ret = ErrorString; 
            return false;
        }

        if (JsonObj !== null &&
            JsonObj.hasOwnProperty('StatusCode') && 
            //JsonObj['StatusCode'] === 200 &&
            JsonObj.hasOwnProperty('Result')) 
        {
            outData.ret = ResultJsonStr;
            //console.log('data2= '+result);
            return true;
        } else {
            //ErrorStr = null;
            outData.ret = ResultJsonStr; 
            return false;
        }
}


var wsnCApi = function( cmd, cb )
{
    var param = cmd.split(" ");
    var action = ' GET ';
    var rest = param[2];
    var postdata = '';
    var index = cmd.indexOf('POST');
    var outret = {};

    if( index != -1 ) // POST
    {
        action = ' POST ';
        postdata = param[3];
    }

    console.log('C API= ' + action + ' rest= ' + rest + 'post= '+postdata );
    exec(API_PROGRAM + action + rest + ' ' + postdata, function(error, stdout, stderr) {
       var isValidResult = VerifyConsoleOutput(error, stdout, stderr,outret);
       console.log('exec result '+ isValidResult);
       console.log('data= '+outret.ret);
       if( cb != undefined )
            cb(0, outret.ret, null); 
        
    });
}

// cb: error, result, stderr (null)
var wsnRestAPI = function( cmd, cb )
{

    var uri = cmd.split(" "); 
    var uRL = '/';
    var result = '';
    var index = -1;
    var action = 'GET';
    var postdata = '';


    index = cmd.indexOf('IoTGW');
    if( index != -1 ) // IoTGW
    {
        uRL += gwPrefixPath + uri[2];
    }
    else
    {
        index = cmd.indexOf('SenHub');
        if( index != -1 ) 
        {
            uRL += senHubPrefixPath + uri[2];
        }

    }


    // parse 'Action'
    index = cmd.indexOf('POST');
    if( index != -1 ) // POST
    {
        action = 'PUT';
        postdata = uri[3];
    }

    //console.log('put data '+postdata);

    var options = { host: serverIP, port: serverPort, path: uRL, method: action, headers: {'Content-Type': 'application/json'}};

    //console.log('option='+JSON.stringify(options));
    //console.log('url= '+uRL);

    callback = function(response) {

        //another chunk of data has been recieved, so append it to `str`
        response.on('data', function (chunk) {
            result += chunk;
        });

        //the whole response has been recieved, so we just print it out here
        response.on('end', function () {        
            //console.log(result);

            var resultToString = '{"StatusCode":';
            if(response.statusCode == 200)
            {
                resultToString +=200 +',"Result":'+result+'}'               
            }
            else
            {
                resultToString += response.statusCode + ',"Result":{"sv":"Failed"}}';  
            }
            
            if( cb != undefined )
                cb(0, resultToString, null);        
        });
    }


    try{
    var req = http.request(options, callback);
    }catch (e) {
       console.log('uncaughExecption 11111');
    }
    if(action==='PUT') {
       req.write(postdata);
    }

    req.on('error', function (e) {
    // General error, i.e.
    //  - ECONNRESET - server closed the socket unexpectedly
    //  - ECONNREFUSED - server did not listen
    //  - HPE_INVALID_VERSION
    //  - HPE_INVALID_STATUS
    //  - ... (other HPE_* codes) - server returned garbage
    var resultToString = '{"StatusCode":500,"Result":{"sv":"WSN Service is not available"}}';
        console.log(e);
        if( cb != undefined ) {
            cb(0, resultToString, null);  
        }  else
            console.log('call is null'); 
    });

    req.on('timeout', function () {
        // Timeout happend. Server received request, but not handled it
        // (i.e. doesn't send any response or it took to long).
        // You don't know what happend.
        // It will emit 'error' message as well (with ECONNRESET code).
        var resultToString = '{"StatusCode":500,"Result":{"sv":"WSN Service is not available"}}';
            //console.log(e);
            if( cb != undefined )
                cb(0, resultToString, null);   

        console.log('timeout');
        req.abort();
    });  

    req.setTimeout(2000); // 2 sec
    req.end();
}

var wsnApi = function( cmd, cb )
{
    //nsole.log('apiVer = '+apiVer);
    if( apiVer == 1 )
        wsnRestAPI( cmd, cb );
    else
        wsnCApi( cmd, cb );

}




module.exports = {
  wsnRestApi: wsnApi,
};
