'use strict';

var React = require('react-native');
var {
    NativeModules
} = React;

var NativeOnePassword = NativeModules.OnePassword;

var OnePassword = {
    isSupported() {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.isSupported(function(error) {
                if (error) {
                    return reject(error.message);
                }

                resolve(true);
            });
        });
    },

    findLogin(url, sender) {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.findLogin(url, sender, function(error, data) {
                if (error) {
                    return reject(error.message);
                }

                resolve(data);
            });
        });
    }
};

module.exports = OnePassword;
