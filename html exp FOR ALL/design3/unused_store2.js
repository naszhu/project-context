study.forEach((obj, idx) => {

    obj.studyPos_currentList_initial = idx + 1;
    obj.testPos_currentList_initial = test.findindex(s_obj=>s_obj.id_picName === obj.id_picName) + 1;
    
    obj.studyPos_priorList_initial = 0;
    obj.testPos_priorList_initial = 0; 

    obj.studyPos_nextList_initial = 0;
    obj.testPos_nextList_initial = 0; 
    
    
    // obj.testPos_final = All have already assigned; Cause there is no prior item

    idx_count++;

    obj.is_studiedCurrentList = 1;
    obj.is_testedCurrentList = obj.testPos_currentList_initial !== 0 ;
    obj.is_testedNextList = ['Cn',"Dn"].includes(obj.stimulusConditions) ? true : false;
    obj.is_studiedPriorList = false;
    obj.is_testedPriorList = false;
    
    obj.is_fromPriorList =  false; 
    obj.is_fromCurrentList = !obj.is_fromPriorList;

    obj.assignmentTypesWithinList = ['A','Cn'].includes(obj.stimulusConditions) ? "target" : "nontarget"; 
    obj.taskType = "study"; 
    

});
test.forEach((obj, idx) => {

    is_currentObj_PriorItem = obj.listNum !== ilist

    obj.studyPos_currentList_initial = study.findindex(t_obj=>t_obj.id_picName === obj.id_picName) + 1;
    obj.testPos_currentList_initial = idx + 1;
    
    if (condi==="f"){
        obj.testPos_final = is_currentObj_PriorItem ? AllTargetFinalPos_store_map.get(obj.id_picName) : 0;
    } else if (condi === "b"){

    } else if (condi === "r"){

    } else null;

    obj.is_studiedCurrentList = obj.studyPos_currentList_initial !== 0;
    obj.is_testedCurrentList = true;
    obj.is_testedNextList = ['Dn',"Cn", "Fnn"].includes(obj.stimulusConditions) && obj.listNum === ilist; //?true :false
    obj.is_fromPriorList = is_currentObj_PriorItem; 

    obj.is_studiedPriorList = is_currentObj_PriorItem && ['Dn',"Cn"].includes(obj.stimulusConditions);
    obj.is_testedPriorList = is_currentObj_PriorItem && 'Fnn' === obj.stimulusConditions;
    
    obj.is_fromCurrentList = !is_currentObj_PriorItem;

    obj.assignmentTypesWithinList = ['B','Dn'].includes(obj.stimulusConditions) ? "target" : "foil";
    obj.taskType = "test";
});


//discard idea below///////////////////////////
            //The "currrent" list values will not be coded in the objects, because the objects I use share the same content, and it will create a conflict if doing so; Rather, the concept of "current" will be introduced during EXP and in Data 
            //IMPORTANT: Mindset to understand the following algorithm: The standpoint (the center of object at question) is the item itself, rather than a trial. So, an item is gonna be reapeated possibly, and so it could have two values, which would be different depending on standing at which trial. ==> Item is the standpoint here!!!

///
//////////////////////////////////////////////////////////////////////////
obj.studyPos_currentList_initial = idx + 1;

obj.is_studiedCurrentList = true;
obj.is_testedNextList = ['Cn',"Dn"].includes(obj.stimulusConditions) ? true : false;

obj.is_fromPriorList =  false; 
obj.is_studiedPriorList = false;
obj.is_testedPriorList = false;

obj.is_fromCurrentList = !obj.is_fromPriorList;
obj.assignmentTypesWithinList = ['A','Cn'].includes(obj.stimulusConditions) ? "target" : "nontarget";

obj.testPos_currentList_initial = obj.assignmentTypesWithinList === 'nontarget' ? 0 : obj.testPos_currentList_initial; 
obj.is_testedCurrentList = obj.testPos_currentList_initial !==0 ? obj.is_testedCurrentList : false; 


/////////////////////////////////////////////////////////////
ilist===0 ? 0 : study_lists[i-1].find(iobj=>iobj.id_picName===obj.id_picName).studyPos_firstAppear_initial;

ilist===0 ? 0 : test_lists[i-1].find(iobj=>iobj.id_picName===obj.id_picName).testPos_firstAppear_initial;

//////////test original code





/////////////////////////Discard again for study obj
    // obj.firstAppear = true;
    obj.assignmentTypesWithinList = ['A','Cn'].includes(obj.stimulusConditions) ? "target" : "nontarget"; 

    obj.studyPos_firstAppear_initial = idx + 1;//there is no second studypos for an item
    obj.is_studiedCurrentList_firstAppear_initial = true; //no second appear here 

    //The following are especially required for 'nontargets'
    //  It is the only chance for this kind to be assigned with the following properties 
    obj.testPos_firstAppear_initial = obj.assignmentTypesWithinList === 'nontarget' ? 0 : obj.testPos_firstAppear_initial;
    obj.is_testedCurrentList_firstAppear_initial = obj.testPos_firstAppear_initial !==0 ? obj.is_testedCurrentList : false; 

    // obj.testPos_secondAppear_initial is assigned after the for loop

    obj.studyPos_prior_FirstAppear_initial = 0;
    obj.is_studiedPriorList_firstAppear_initial = false;
    obj.studyPos_prior_secondAppear_initial = 0;
    obj.is_studiedPriorList_firstAppear_initial = false;

    obj.testPos_priorAppear_firstAppear_initial = 0;
    obj.is_testedPriorList_firstAppear_initial = false;
    obj.testPos_priorAppear_secondAppear_initial = 0;
    obj.is_testedPriorList_secondAppear_initial = false;

    // obj.is_testedPriorList = false;
    
    obj.is_fromPriorList_firstAppear_initial =  false; 
    obj.is_fromPriorList_secondAppear_initial =  false; 
    // obj.is_studiedPriorList = false;

    obj.is_fromCurrentList_firstAppear_initial = !obj.is_fromPriorList_firstAppear_initial;
    obj.is_fromCurrentList_secondAppear_initial = null;

    // obj.testPos_firstAppear_initial = obj.assignmentTypesWithinList === 'nontarget' ? 0 : obj.testPos_firstAppear_initial; 

    // obj.testPos_final = All have already assigned; Cause there is no prior item



    
/////////////////////////Discard again for tests obj
test.forEach((obj, idx) => {

    //current obj concept exist in terms of the obj at hand of discussion of the 'test' variable, but not a current concept for the trial
    is_currentObj_PriorItem = obj.listNum !== ilist;
    obj.current_assignmentTypesWithinList = ['Fn','Fnn'].includes(obj.stimulusConditions) ? "foil" : obj.current_assignmentTypesWithinList;


    if (obj.anRepeatedItem){//is_currentObj_PriorItem
       //This gives Dn+1; Dn; Cn; Fnn+1; Fnn; (left with B and Fn+1)
       //when is_currentObj_PriorItem true, gives Dn+1，Fnn+1; else: Dn, Cn, Fnn

        obj.testPos_firstAppear_initial = is_currentObj_PriorItem ? idx + 1 : obj.testPos_firstAppear_initial;
        // obj.testPos_secondAppear_initial is assigned after the for loop
        obj.is_testedCurrentList_firstAppear_initial = is_currentObj_PriorItem ? true : obj.is_testedCurrentList_firstAppear_initial; 

        //only need to give value for Fnn, others already have assigned elsewhere
        obj.studyPos_firstAppear_initial = !is_currentObj_PriorItem ? current_assignmentTypesWithinList==='foil' ? 0 : obj.studyPos_firstAppear_initial : obj.studyPos_firstAppear_initial;//there is no second studypos for an item
        obj.is_studiedCurrentList_firstAppear_initial = !is_currentObj_PriorItem ? current_assignmentTypesWithinList==='foil' ? false : obj.studyPos_firstAppear_initial : obj.studyPos_firstAppear_initial; //no second appear here 


        obj.studyPos_prior_FirstAppear_initial = is_currentObj_PriorItem ? 0 : obj.studyPos_prior_FirstAppear_initial;
        obj.is_studiedPriorList_firstAppear_initial = is_currentObj_PriorItem ? false : obj.studyPos_prior_FirstAppear_initial;
        
        obj.studyPos_prior_secondAppear_initial = is_currentObj_PriorItem ? null : ; //this is exactly 
        obj.is_studiedPriorList_firstAppear_initial = false;

    }else if (!obj.anRepeatedItem){

    }

    obj.studyPos_prior_FirstAppear_initial = is_currentObj_PriorItem && obj.anRepeatedItem ? obj.studyPos_prior_FirstAppear_initial : ;
    obj.is_studiedPriorList_firstAppear_initial = false;
    obj.studyPos_prior_secondAppear_initial = 0;
    obj.is_studiedPriorList_firstAppear_initial = false;

    obj.testPos_priorAppear_firstAppear_initial = 0;
    obj.is_testedPriorList_firstAppear_initial = false;
    obj.testPos_priorAppear_secondAppear_initial = 0;
    obj.is_testedPriorList_secondAppear_initial = false;

    if (!is_currentObj_PriorItem){

        //The following are especially required for 'nontargets'
        //  It is the only chance for this kind to be assigned with the following properties 
        // obj.testPos_firstAppear_initial = obj.current_assignmentTypesWithinList === 'nontarget' ? 0 : obj.testPos_firstAppear_initial;

        // obj.testPos_secondAppear_initial is assigned after the for loop

        obj.studyPos_prior_FirstAppear_initial = 0;
        obj.is_studiedPriorList_firstAppear_initial = false;
        obj.studyPos_prior_secondAppear_initial = 0;
        obj.is_studiedPriorList_firstAppear_initial = false;

        obj.testPos_priorAppear_firstAppear_initial = 0;
        obj.is_testedPriorList_firstAppear_initial = false;
        obj.testPos_priorAppear_secondAppear_initial = 0;
        obj.is_testedPriorList_secondAppear_initial = false;

        // obj.is_testedPriorList = false;
        
        obj.is_fromPriorList_firstAppear_initial =  false; 
        obj.is_fromPriorList_secondAppear_initial =  false; 
        // obj.is_studiedPriorList = false;

        obj.is_fromCurrentList_firstAppear_initial = !obj.is_fromPriorList_firstAppear_initial;
        obj.is_fromCurrentList_secondAppear_initial = null;

    }

});

///////////////////Final test assignment part

            // Assign presentation positions for NEW items n each list
            //the following applies for all lists
            //Here, all final Target's final positions has been used. 
            const allCurrentListNewItems = [A_items,B_items,Cn_items,Dn_items,Fn_items,Fnn_items];
            //the following assignment applies to all lists
            let idx_c = 0;
            // AllTargetFinalPos_Map = 
            if (['r','f'].includes(condi)){
                allCurrentListNewItems.forEach(arrnow =>{arr.forEach(obj=>{
                    obj.testPos_final = obj.is_chosenFinal ? finalTestIndex_arr[ilist][idx_c] : 0;
                    idx_c++
                    AllTargetFinalPos_store_map.set(obj.id_picName,obj.testPos_final);
                })})
            }





//////////////////////////////////////
obj.studyPos_priorPos_firstAppear_initial = study_lists[i-1].findIndex(iobj=>iobj.id_picName===obj.id_picName)+1; //a tricky findout
obj.testPos_priorPos_firstAppear_initial = test_lists[i-1].findIndex(iobj=>iobj.id_picName===obj.id_picName)+1;//a tricky findout

obj.studyPos_nextPos_firstAppear_initial = obj.anRepeatedItem ? "don't know the next trial value, assign later" : 0;
obj.testPos_nextPos_firstAppear_initial = obj.anRepeatedItem ? "don't know the next trial value, assign later" : 0; 

obj.studyPos_currPos_firstAppear_initial = obj.current_assignmentTypesWithinList === "target" ? study.findIndex(iobj=>iobj.id_picName===obj.id_picName)+1 : 0; //a tricky find out
obj.testPos_currPos_firstAppear_initial =  idx+1; //a tricky method used here in finding pos, though this hasn't been assigned first


////////discard study again
                ///////////////// First appear - 6 var
                obj.studyPos_priorPos_firstAppear_initial = 0; //as a first appearance, it wouldn't have a prior position
                obj.testPos_priorPos_firstAppear_initial = 0;//as a first appearance, it wouldn't have a prior position

                obj.studyPos_nextPos_firstAppear_initial = 0;
                obj.testPos_nextPos_firstAppear_initial = obj.anRepeatedItem ? "don't know here, assign later" : 0; 

                obj.studyPos_currPos_firstAppear_initial = idx + 1;
                obj.testPos_currPos_firstAppear_initial =  obj.current_assignmentTypesWithinList==="target" ? test.findIndex(iobj=>iobj.id_picName===obj.id_picName)+1 : 0; //a tricky method used here in finding pos, though this hasn't been assigned first

                /////////////// Second appear - 6 var
                obj.studyPos_priorPos_secondAppear_initial = 0; 
                obj.testPos_priorPos_secondAppear_initial = 0;

                obj.studyPos_nextPos_secondAppear_initial = 0;
                obj.testPos_nextPos_secondAppear_initial = 0; 

                obj.studyPos_currPos_secondAppear_initial = 0;
                obj.testPos_currPos_secondAppear_initial =  0; 

                /////////////// Current appear - 6 var
                if (obj.is_currentObjAFirstAppearedObj){

                    obj.studyPos_priorPos_currAppear_initial = obj. studyPos_priorPos_firstAppear_initial; 
                    obj.testPos_priorPos_currAppear_initial = obj. testPos_priorPos_firstAppear_initial;
                    obj.studyPos_nextPos_currAppear_initial = obj. studyPos_nextPos_firstAppear_initial;
                    obj.testPos_nextPos_currAppear_initial = obj. testPos_nextPos_firstAppear_initials; 

                    obj.studyPos_currPos_currAppear_initial = obj. studyPos_currPos_firstAppear_initial;
                    obj.testPos_currPos_currAppear_initial =  obj.testPos_currPos_firstAppear_initial ; 
                }