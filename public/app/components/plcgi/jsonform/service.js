angular.module('jsonform.services', ['jsonform.directives'])
.filter(
	'getValue',function(){
		return function(input){
			if (input && input.value) {
				return input.value;
			}
			return input;
		}
	}
)
.service('jsonformService', [
	'$rootScope', 
	'$http',
	'$routeParams',
	'Location',
	'SharedService',
	function($rootScope,$http,$routeParams,Location,SharedService) {
		// vars for initialize in module
		var $scope,$attrs;

		/********** Private methods ************/
		/*
		* @name randomString
		* @description get random string for set "id" to elements
		* @returns random number-letter string
		*/
		var randomString = function (length) {
			var text = "";

			var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			
			for( var i=0; i < length; i++ )
				text += possible.charAt(Math.floor(Math.random() * possible.length));
		
			return text;
		}
		
		/*
		* @name parseArgs
		* @description arguments parser and converter to inline format
		* 
		*/	
		var parseArgs = function() {
			$scope.meta.formId = randomString(5);
			
			var fields = $scope.meta.fields;
			
			var groups = {};
			
			var model;
			if ($scope.id) {
				model = search($scope.id);
			}
			
			for (var i = 0; i < fields.length; i++) {
				
				if(model) {
					fields[i].value = model[fields[i].name].value;
					fields[i].required = model[fields[i].required] || false;
				}
				else {
					fields[i].value = undefined;
				}
				fields[i].id    = 'fld'+randomString(5);
				if( typeof groups[fields[i].group.name] === 'undefined' ) {
					groups[fields[i].group.name] = {
						name : fields[i].group.name,
						label : fields[i].group.label,
						fields : []
					};
				}
				
				groups[fields[i].group.name].fields.push(fields[i]);
			}
			var newGroups = [];
			// convert input meta.json to directive format for group fields by groups
			for ( var item in groups ) {
				newGroups.push({
					name : groups[item].name,
					label : groups[item].label,
					fields : groups[item].fields
				});
			}
			delete $scope.meta.fields;
			$scope.meta.groups = newGroups;
		    			
			if (model) {
				$scope.model = model;
			}
			else {
				$scope.model = {};
			}
		};
		/*
		* @name error
		* @description callback to show errors
		* 
		*/
		var error = function($scope,data, status, headers, config){
			$scope.error = data;
		};
		
		/*
		* @name search
		* @description search account info from account. model
		* @returns account info or undefined
		*/
		var search = function(id) {
			var res;
			var models = $scope.models;
			
			for (var i = 0; i < models.length; i++) {
				if (id === models[i].Id) {
					res = models[i];
					
					break;
				}
			}
			
			return res;
		};
		
		// variable to use 'this' in other functions
		var self        = this;
		
		/******************************/
		/****** public interface ******/
		/******************************/
		
		/*
		* @name initialize
		* @description constructor to initialize module object in controller
		* 
		*/
		var initialize = function(scope,attrs){
			$scope = scope;
			$attrs = attrs;
			$scope.id       = Location.param('id') || $attrs.id;
			
			$scope.getValue = function(data){
				return data;
			}
		
			if ( typeof $scope.id == 'undefined' ) {
				$scope.mode = 'edit';
			}
			else {
				$scope.mode   = Location.param('mode') || $attrs.mode || 'view';
			}
			get();
		};
		/*
		* @name get
		* @description get data from server
		* 
		*/
		var get = function(){
			// clear error from scope
			delete $scope.error;
			// try to get data defined in directive
			
			$http({
				method: 'GET',
				url: $attrs.meta
			}).
			success(function(data, status, headers, config) {
				$scope.meta = data;
				if ($scope.models) {
					parseArgs();
						
					// share data with any subscribers
					SharedService.prepForBroadcast($scope.models,$scope.meta);
				}
				else {
					$http({
						method: 'GET',
						url: $attrs.data
					}).
					success(function(data, status, headers, config) {
						
						$scope.models = data.models;
						parseArgs();
						
						// share data with any subscribers
						SharedService.prepForBroadcast(data.models,$scope.meta);
					}).
					error(function($scope,data, status, headers, config){error($scope,data, status, headers, config)})	
				}
			}).
			error(function($scope,data, status, headers, config){error($scope,data, status, headers, config)})
		};
		/*
		* @name save
		* @description save data for directive - in memory,on server etc
		* 
		*/
		var save = function(model){
			
			if ( !model.Id ) {
				model.Id = randomString(20);
				$scope.models.push(model);
			}

		};
		/*
		* @name changeAccount
		* @description change current account in scope
		* 
		*/
		var changeModel = function(id,mode){
			$scope.id 		= id;
			$scope.mode 	= mode;
			$scope.model 	= search(id);			
		}
		
		/*
		* @name clearFields
		* @description clear fields in form before add new account to account array
		* 
		*/
		var clearFields = function(){
			$scope.model  = {};
			$scope.mode 	= 'edit';
		};
		
		
		return {
			initialize: initialize,
			get: get,
			save: save,
			changeModel: changeModel,
			clearFields: clearFields
		}
	}
]);