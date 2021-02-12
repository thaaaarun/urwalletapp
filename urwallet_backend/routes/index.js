const express = require('express');
const Router = require('express-promise-router');

const router = new Router()

const {getDatabase} = require('../database/database');


router.get("/refresh/:netId", async (req, res, next) => {
    // get a dicationary of the currencies and their values
    // get the last 5 transactions
    let netId = req.params.netId;
    if (!netId) {
        await res.json({success: false, error_msg: "Bad request."});
        return;
    }

    const database = await getDatabase();

    let account_data = (await database.ref('/accounts/' + netId).once('value')).val();
    if (!account_data) {
        await res.json({success: false, error_msg: "Account does not exist."});
        return;
    }
    
    let data = {
        account_balances: {
            declining: account_data.account_balances.declining,
            uros: account_data.account_balances.uros,
            printer: account_data.account_balances.printer
        },
        transaction_history: account_data.transactions
    };

    await res.json({success: true, data: data}); 
});


router.post("/sendmoney", async (req, res, next) => {
    let sender_id = req.body.sender_id;
    let receiver_id = req.body.receiver_id;
    let amount = req.body.amount;
    let account_type = req.body.account_type;

    if (!(sender_id && receiver_id && amount && account_type)) {
        await res.json({success: false, error_msg: "Bad request."});
        return;
    }
    
    const database = await getDatabase();

    // TODO:
    /*
    1) How to prevent concurrency issues ==> move the receiver stuff inside the sender stuff; when to do validation?
    2) Can we merge two database queries into a single request
    */

    // check that the amount to send is > 0
    if (amount <= 0)
    {
        await res.json({success: false, error_msg: "Amount must be positive."});
        return;
    }

    // ALL GETs
    //gets receiver data
    let receiver_account_data = (await database.ref('/accounts/' + receiver_id).once('value')).val();
    
    //check that the receiver Id exists in the DB
    if (!receiver_account_data) {
        await res.json({success: false, error_msg: "Receiver account does not exist."});
        return;
    }

    //gets sender data
    let sender_account_data = (await database.ref('/accounts/' + sender_id).once('value')).val();

    //check that the sender has enough money
    if (amount > sender_account_data.account_balances[account_type])
    {
        await res.json({success: false, error_msg: "Not enough funds :("});
        return;
    }

    
    // Update sender account
        
    // Write the new post's data simultaneously in the posts list and the user's post list.
    let updates = {};
    updates['/accounts/' + sender_id + '/account_balances/' + account_type] = sender_account_data.account_balances[account_type] - amount;
    //console.log(updates);

    // Create new transaction record
    let newTransactionKey = database.ref().child('transactions').push().key;
    updates['/accounts/' + sender_id + '/transactions/' + newTransactionKey] = {  
        amnt: -amount,
        currency: account_type,
        loc: ("Transfer from " + sender_id + " to " + receiver_id),
        unix_epoch_ms: Date.now()
    };

    // await database.ref().update(updates);


    // Upadate receiver account
    
    // Write the new post's data simultaneously in the posts list and the user's post list.
    updates['/accounts/' + receiver_id + '/account_balances/' + account_type] = receiver_account_data.account_balances[account_type] + amount;
    //console.log(updates);
    
    // Create new transaction record
    newTransactionKey = database.ref().child('transactions').push().key;
    updates['/accounts/' + receiver_id + '/transactions/' + newTransactionKey] = {  
        amnt: amount,
        currency: account_type,
        loc: ("Transfer from " + sender_id + " to " + receiver_id),
        unix_epoch_ms: Date.now()
    };

    await database.ref().update(updates);


    // Create transactions for both sender and receiver
    // loc --> "sender_id to receiver_id"

    // Success
    await res.json({success: true});
});

module.exports = router;