/**
 * File: Javascripts/SimpleValidation.js
 * This script is used to do simple validation on a form. It basically
 * just makes sure all the fields have values. To force a field to be
 * skipped you can either set it to disabled, or add it to the 
 * VAL_SKIP_FILEDS object using the form name as the key. For example:
 * (code)
 * VAL_SKIP_FIELDS["ADDRESS_2"] = 1;
 * (end code)
 * will skip the field named ADDRESS_2
 *
 * To use the script, add it to the onsubmit attribute to the form element
 * and pass in the form name (defined by the name attribute on the form element)
 * (code)
 * <form ... name="mainform" ... onsubmit="return simpleValidate('mainform');" ...
 * (end code) 
 *
 * Copyright:
 * 	2006 Rohan (robrohan@gmail.com)
 */

/**
 * Variable: VAL_SKIP_FIELDS:
 * form elements not to check for existance
 */
var VAL_SKIP_FIELDS = new Object;

function simpleValidate(frm) {
	//make sure they put something into every form element
	var mainform = document.forms[frm];
	var elelen = mainform.elements.length;
	var passed = true;
	
	try{
		for(var x=0; x<elelen; x++) {
			var currentItem = mainform.elements[x];
			switch(currentItem.type){
				case "text":
					currentItem.className = "inputClear";
					if(currentItem.value.toString().length < 1 && !currentItem.disabled){
						if(typeof VAL_SKIP_FIELDS[currentItem.name.toString()] == "undefined")
						{
							currentItem.className = "inputError";
							passed = false;
						}
					}
				break;
				case "select-one":
					currentItem.className = "inputClear";
					if(currentItem.selectedIndex == 0 && !currentItem.disabled){
						if(typeof VAL_SKIP_FIELDS[currentItem.name.toString()] == "undefined")
						{
							currentItem.className = "inputError";
							passed = false;
						}
					}
				break;
				case "hidden":
				case "radio":
				default:
					//nothing
			}
		}
	}catch(e){
		return false;
	}
	
	if(!passed){
		alert("All form fields need to be filled out.\nPlease ensure all fields have values");
	}else{
		var linkele = document.getElementById("redir");
	}
	
	return passed;
}

function toggleSecondText(sel,id){
	var txtbox = document.getElementById(id);
	if(sel.selectedIndex == 0)
		txtbox.disabled = false;
	else
		txtbox.disabled = true;
}
