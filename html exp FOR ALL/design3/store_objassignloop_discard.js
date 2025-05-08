







let study_lists_arrArrObj_inUse = [];//array of objects
let test_lists_arrArrObj_inUse = [];

// let AllTargetFinalPos_store_map = new Map();
// console.log("Ss",master_obj_arr_arrObj_initial)
let finalTest_lists_arr_arrObj = [];

for (let ilist = 0; ilist < n_lists_singular; ilist++){
    // console.log("first",ilist)
    // Combine items for this list
    let finalTest_lists_arrObj = [];

    const A_items = master_obj_arr_arrObj_initial.A[ilist];
    const B_items = master_obj_arr_arrObj_initial.B[ilist];
    const Cn_items = master_obj_arr_arrObj_initial.Cn[ilist];
    const Dn_items = master_obj_arr_arrObj_initial.Dn[ilist];
    const Fn_items = master_obj_arr_arrObj_initial.Fn[ilist];
    const Fnn_items = master_obj_arr_arrObj_initial.Fnn[ilist];
    const Dn_priorList_items = ilist!==0 ? master_obj_arr_arrObj_initial.Dn[ilist-1] : undefined; 
    const Cn_priorList_items = ilist!==0 ? master_obj_arr_arrObj_initial.Cn[ilist-1] : undefined;
    const Fnn_priorList_items = ilist!==0 ? master_obj_arr_arrObj_initial.Fnn[ilist-1] : undefined;

    // Define study and test for this list
    let study = deepcopyarobj(shuffleArray([...A_items, ...B_items, ...Cn_items, ...Dn_items]));//Cn,Dn goes to next; A, B current 
    let test = deepcopyarobj(shuffleArray(
        ilist === 0
            ? [...B_items, ...Dn_items, ...Fn_items, ...Fnn_items]
            : [...B_items, ...Dn_items, ...Fn_items, ...Fnn_items, ...Dn_priorList_items, ...Cn_priorList_items, ...Fnn_priorList_items]
    ));//(B Dn) from current; (Fnn_l,Cn_l,Dn,l) from last list; (Fn, Fnn) current new            

    //In the following, I will assign types with their n+1 trial name:
    // A, Cn+1, B, Dn+1 || B, Dn+1, Dn, Cn, Fnn+1, Fn+1, Fnn 
    // let icount = 0;
    // ilist===1 ? console.log("study:::", study) : null;
    study.forEach((obj, idx) => {//only type A, Cn, B, Dn

        currAssign = obj.stimulusConditions;
        if (['B','A'].includes(currAssign)){
            currAssign_nPlusOneTrial = currAssign;
            // obj.stimulusConditionName_nPlusOneTrial = currAssign;
        }else if (['Cn','Dn'].includes(currAssign)){
            currAssign_nPlusOneTrial = currAssign; + "+1";
            // obj.stimulusConditionName_nPlusOneTrial = currAssign + "+1";
        }

        if (['f','r'].includes(condi)){
            if (obj.is_chosenFinal){
                obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                finalTest_lists_arrObj.push(obj_iFinalFoil);
                finalTest_lists_arrObj.push(obj);
            }else{
                obj.testPos_final = 0;
            }
            // if (ilist===1){ 
            //         console.log("studyobj",idx, obj.testPos_final,obj)
            // }
        }else if ('b'===condi){
            if (['A','B'].includes(currAssign_nPlusOneTrial)){

                if (obj.is_chosenFinal){
                    obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                    obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    finalTest_lists_arrObj.push(obj_iFinalFoil);
                    finalTest_lists_arrObj.push(obj);
                }else{
                    obj.testPos_final = 0;
                }
            }else if (['Cn+1','Dn+1'].includes(condi)) {
                obj.testPos_final = "don't konow yet";
                if (ilist === (n_lists_singular-1)){

                    if (obj.is_chosenFinal){
                        obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                        obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                        obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                        finalTest_lists_arrObj.push(obj_iFinalFoil);
                        finalTest_lists_arrObj.push(obj);
                    }else{
                        obj.testPos_final = 0;
                    }
                }
                //Cn+1, Dn+1 find testposition in next test pos
            }
        }

        obj.is_old = null;
        obj.correct_response_key = null;
        obj.listNum_currTest_initial = ilist+1;
        obj.stimulusConditionName_nPlusOneTrial = currAssign_nPlusOneTrial;

        
        obj.current_assignmentTypesWithinList = ['A','Cn'].includes(obj.stimulusConditions) ? "T_target" : "T_nontarget"; // keep this for now
        obj.is_currentObjAppear1 = true;
        obj.num_CurrObjAppear = 1;

        obj.studyPos_appear1_initial = idx + 1;
        obj.testPos_appear1_initial = obj.current_assignmentTypesWithinList==="T_target" ? test.findIndex(iobj=>iobj.id_picName===obj.id_picName)+1 : 0;
        obj.is_studied_appear1_initial = true;
        obj.is_tested_appear1_initial = obj.testPos_appear1_initial === 0 ? false : true;

        obj.studyPos_appear2_initial = 0;
        obj.testPos_appear2_initial = obj.anRepeatedItem ? "don't know here, assign later" : 0;
        obj.is_studied_appear2_initial = false;
        obj.is_tested_appear2_initial = obj.anRepeatedItem ? "don't know here, assign later" : false; 

        obj.studyPos_appear0_initial = obj.studyPos_appear1_initial;
        obj.testPos_appear0_initial = obj.testPos_appear1_initial;
        obj.is_studied_appear0_initial = obj.is_studied_appear1_initial;
        obj.is_tested_appear0_initial = obj.is_tested_appear1_initial;

        obj.currentTask = "study";
    });

    // A, Cn+1, B, Dn+1 || B, Dn+1, Dn, Cn, Fnn+1, Fn+1, Fnn 
    // console.log(study,test)
    // ilist===1 ? console.log("test:::", test) : null;
    test.forEach((obj, idx) => {
        
        obj.listNum_currTest_initial = ilist+1;
        crrObjListNum_jsidx = obj.listNum_firstAppear_initial -1;

        currAssign = obj.stimulusConditions;
        if (['B','Fn'].includes(currAssign)){
            currAssign_nPlusOneTrial = currAssign;
            if (currAssign==='Fn'){//the name of Fn is special
                currAssign_nPlusOneTrial = currAssign + "+1"
            }
        }else if (['Cn','Dn','Fnn'].includes(currAssign)){

            if (crrObjListNum_jsidx === ilist){
                currAssign_nPlusOneTrial = currAssign + "+1" ;
            }else{
                currAssign_nPlusOneTrial = currAssign
                obj.type_comment = obj.type_comment + ", from last trial"
            }
             //when ilist=1; all obj listNum_firstAppear_initial=1,thus no item is named Cn, Dn or Fnn, they are all named Cn+1, Dn+1, Fnn+1, so they won't go through the following finding of [ilist-1], the following code doesn't have a problem
        }

        curr_nPlusOneTrial_itemName = obj.stimulusConditionName_nPlusOneTrial;

        if (['f','r'].includes(condi)){
            if (['Fnn+1','Fn+1'].includes(currAssign_nPlusOneTrial)){

                if (obj.is_chosenFinal){
                    obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                    obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    finalTest_lists_arrObj.push(obj_iFinalFoil);
                }else{
                    obj.testPos_final = 0;
                }
                // if (ilist===1){ 
                //     console.log("testobj", idx,obj.testPos_final,obj)
                // }
            }else if (['B','Dn+1'].includes(currAssign_nPlusOneTrial)){
                obj.testPos_final = study.find(istudy=>istudy.id_picName === obj.id_picName).testPos_final;//tricky findout here
            }else if (['Dn','Fnn'].includes(currAssign_nPlusOneTrial)){
                obj.testPos_final = test_lists_arrArrObj_inUse[ilist-1].find(itest=>itest.id_picName === obj.id_picName).testPos_final;
            }else if ('Cn'===currAssign_nPlusOneTrial){
                obj.testPos_final = study_lists_arrArrObj_inUse[ilist-1].find(istudy=>istudy.id_picName === obj.id_picName).testPos_final;
            }

            
        }else if ('b'===condi){
            if (['Dn','Cn','Fnn','Fn+1'].includes(currAssign_nPlusOneTrial)){

                if (obj.is_chosenFinal){
                    obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                    obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    finalTest_lists_arrObj.push(obj_iFinalFoil);
                }else{
                    obj.testPos_final = 0;
                }
                // icount ++;
            }else if (['B','Dn+1'].includes(currAssign_nPlusOneTrial)){
                obj.testPos_final = study.find(istudy=>istudy.id_picName = obj.id_picName).testPos_final;
            }else if ('Fnn+1' === currAssign_nPlusOneTrial){
                obj.testPos_final = "don't know yet";
                if (ilist === (n_lists_singular-1)){

                    if (obj.is_chosenFinal){
                        obj.testPos_final =  finalTestIndex_arr_shallowCopy[ilist].pop(1);
                        obj_iFinalFoil = master_obj_arrObj_finalFoil_shallowCopy[currAssign].pop(1);
                        obj_iFinalFoil.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                        finalTest_lists_arrObj.push(obj_iFinalFoil);
                    }else{
                        obj.testPos_final = 0;
                    }
                    // obj.testPos_final = finalTestIndex_arr_shallowCopy[ilist].pop(1);
                    // finalTest_lists_arrObj.push(master_obj_arrObj_finalFoil_shallowCopy.pop(1))
                }
            }
        }

        obj.stimulusConditionName_nPlusOneTrial = currAssign_nPlusOneTrial;

        // is_currentObj_PriorItem = obj.listNum_firstAppear_initial !== ilist;
        obj.is_currentObjAppear1 = crrObjListNum_jsidx === ilist;

        curr_isTarget = ['B','Dn'].includes(obj.stimulusConditions) &&  crrObjListNum_jsidx===ilist ? true : false;
        obj.current_assignmentTypesWithinList = curr_isTarget ? "T_target" : "T_foil"; 
        // console.log(il)

        obj.is_old = obj.current_assignmentTypesWithinList === curr_isTarget;
        obj.correct_response_key = curr_isTarget ? 'j' : 'f';

        if (obj.is_currentObjAppear1) { //list 1 only go throug this condition 

            obj.num_CurrObjAppear = 1;
            obj.studyPos_appear1_initial = study.findIndex(iobj=>iobj.id_picName===obj.id_picName)+1;
            obj.testPos_appear1_initial = idx + 1;
            obj.is_studied_appear1_initial = obj.studyPos_appear1_initial === 0 ? false : true;
            obj.is_tested_appear1_initial = true;

            obj.studyPos_appear2_initial = 0; 
            obj.testPos_appear2_initial = obj.anRepeatedItem ? "don't know here, assign later" : 0;//restricted to only type 'Cn+1','Dn+1'
            obj.is_studied_appear2_initial = false;
            obj.is_tested_appear2_initial = obj.anRepeatedItem ? "don't know here, assign later" : false; 

            obj.studyPos_appear0_initial = obj.studyPos_appear1_initial;
            obj.testPos_appear0_initial = obj.testPos_appear1_initial;
            obj.is_studied_appear0_initial = obj.is_studied_appear1_initial;
            obj.is_tested_appear0_initial = obj.is_tested_appear1_initial;
        }else{//only possible to be Dn, Cn, Fnn, when they were the second appear
            // console.log(ilist,obj,study_lists_arrArrObj_inUse[ilist-1].find(iobj=>iobj.id_picName===obj.id_picName))
            obj.num_CurrObjAppear=2;
            if (obj.stimulusConditionName_nPlusOneTrial !== "Fnn"){
                obj.studyPos_appear1_initial = study_lists_arrArrObj_inUse[ilist-1].find(iobj=>iobj.id_picName===obj.id_picName).studyPos_appear1_initial;
            }else{
                obj.studyPos_appear1_initial = 0;
            }

            if (obj.stimulusConditionName_nPlusOneTrial !== "Cn"){
                obj.testPos_appear1_initial = test_lists_arrArrObj_inUse[ilist-1].find(iobj=>iobj.id_picName===obj.id_picName).studyPos_appear1_initial;
            }else{
                obj.testPos_appear1_initial = 0;
            }
            obj.is_studied_appear1_initial = obj.studyPos_appear1_initial === 0 ? false : true;
            obj.is_tested_appear1_initial = obj.testPos_appear1_initial === 0 ? false : true;

            obj.studyPos_appear2_initial = 0;
            obj.testPos_appear2_initial = idx + 1;
            obj.is_studied_appear2_initial = false;
            obj.is_tested_appear2_initial = true; 

            obj.studyPos_appear0_initial = obj.studyPos_appear2_initial;
            obj.testPos_appear0_initial = obj.testPos_appear2_initial;
            obj.is_studied_appear0_initial = obj.is_studied_appear2_initial;
            obj.is_tested_appear0_initial = obj.is_tested_appear2_initial;
        }

        obj.currentTask = "test";
    });

    study_lists_arrArrObj_inUse.push(study);
    test_lists_arrArrObj_inUse.push(test);
    finalTest_lists_arr_arrObj.push(finalTest_lists_arrObj);
};

console.log("finalTestIndex After pop:",finalTestIndex_arr_shallowCopy)

console.log("studylist",study_lists_arrArrObj_inUse)
console.log("testlist",test_lists_arrArrObj_inUse)


//Assign testPos_appear2_initial = obj.anRepeatedItem ? "don't know here, assign later" : 0;
/// is_tested_appear2_initial
//Though maybe a single property function call could handle the following task, the for loop is kept and used because more stuff might be add in later in this part. A for loop will be easier for later usage. 

// let finalTest_lists_arrObj = [];
// let finalTestPositionSet = new Map();
// let itempnow=0;

//finalTest_lists_arr_arrObj
for (let n = 0; n < n_lists_singular ; n++) {

    concat_arr = [...study_lists_arrArrObj_inUse[n], ...test_lists_arrArrObj_inUse[n]];
    // finalTestMapOfMap_ListKey.set(n,concat_arr) 
    if (n < n_lists_singular - 1){
        const nextTestList = test_lists_arrArrObj_inUse[n + 1];
        
        // Now go through current list's study and test objects,
        // Assign the next list test pos in both study and test 
        // testPos_appear2_initial
        for (const obj of concat_arr){

            const nextObj = nextTestMap.get(obj.id_picName);
            obj.testPos_appear2_initial = nextObj ? nextObj.testPos_appear1_initial : 0;
            obj.is_tested_appear2_initial = nextObj ? nextObj.testPos_appear1_initial !==0  : false;

            if (condi==="b"){ //this could be moved to the previous for loop as well, but is instead written here for better clarity
                if (['Cn+1','Dn+1','Fnn+1'].includes(obj.stimulusConditionName_nPlusOneTrial)){
                    obj.testPos_final = nextObj.testPos_final;
                };
            }
        }
    }else{//list 10
        for (const obj of concat_arr){

            obj.testPos_appear2_initial = 0;
        }
    };

    // console.log(n, finalTest_lists_arrObj.length, study_lists_arrArrObj_inUse[n].length, concat_arr)

};