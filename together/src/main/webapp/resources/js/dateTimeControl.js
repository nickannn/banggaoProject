 
 const currentTimestamp = Date.now();
 const minTimestamp = currentTimestamp + 10800000;		// meeting date min -> currentTime + 3시간
 const maxTimestamp = currentTimestamp + 1209600000;	// meeting date max -> currentTime + 14일 

 const minDate = new Date(minTimestamp);
 const maxDate = new Date(maxTimestamp);
 
 // minDate => date string 형식으로 
 let year = minDate.getFullYear();
 let month = minDate.getMonth()+1;
 let day = minDate.getDate();
 
 let hour = minDate.getHours();
 let minute = minDate.getMinutes(); 
 
 if(day < 10) 
 	day = '0' + day;
 	
 if(month < 10) 
 	month = '0' + month; 
 
 const min = year + "-" + month + "-" + day + "T" + hour + ":" + minute;
 
 // maxDate => date string 형식으로
 year = maxDate.getFullYear();
 month = maxDate.getMonth()+1;
 day = maxDate.getDate();
 
 hour = maxDate.getHours();
 minute = maxDate.getMinutes(); 
 
 if(day < 10) 
 	day = '0' + day;
 	
 if(month < 10) 
 	month = '0' + month; 
 
 const max = year + "-" + month + "-" + day + "T" + hour + ":" + minute;
 
 document.querySelector("#meetingDateTime").setAttribute("min", min);
  document.querySelector("#meetingDateTime").setAttribute("max", max);
 document.querySelector("#meetingDateTime").value = min;
 