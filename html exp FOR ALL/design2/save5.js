    function loadDoc() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                
                // gets the entire html file of the folder 'logpost' in this case and labels it thing
                thing = this.responseText
                searchFor = /.html</g
                a=0;
                b=0;
                var str = "";
        
                // greps file for .html and then backs up leter by letter till you hot the file name and all
                while ((dothtmls = searchFor.exec(thing)) != null ){

                    str = "";
                    console.log(dothtmls.index);
                    
                    a = dothtmls.index;

                    while (thing[a]  != '>' ){
                        a--;
                    }
                    a++;
                    while(thing[a] != '<'){
                        str = str + thing[a];
                        a++;
                    }
                    console.log(str);
                } 
            }
        };
    xhttp.open("GET", "logpost/", true);
    xhttp.send();
    }