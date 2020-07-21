const functions = require('firebase-functions');

const admin = require('firebase-admin');
const { user } = require('firebase-functions/lib/providers/auth');

admin.initializeApp(functions.config().firebase);


exports.locationTrigger = functions.firestore.document('Location/{LocationId}')
.onCreate( async(snapshot)=> {
    
    if(snapshot.empty){
        console.log('No Devices');
        return;
    }
    
    var tokens = [];
   
    const deviceTokens = await admin.firestore().collection('DeviceToken').get();

    for(var token of deviceTokens.docs){
        tokens.push(token.data().device_token);
    }

    // const goeoloc = `${snapshot.data().geopoint}`;
    // const userLocation = `${snapshot.data().userLocation[goeoloc]}`;
    // `${snapshot.data['geopoint']}`]

   
 
    var payload = {
            notification: {
                title: 'CRIME ALERT!!',
                body:   "New Crime Alert, Check It Out",
                sound: 'default',
                },
            data: {click_action: 'FLUTTER_NOTIFICATION_CLICK',
                 message: 'User Location'
                }  
    }

    try {
        admin.messaging().sendToDevice(tokens, payload);
        console.log('Pushed Notification Sent!!, Notification Sent!!');
        console.log(payload["data"]["message"]);
       
        
    } catch (error) {
        console.log(error, 'Notification Not Sent!');
    }
});


