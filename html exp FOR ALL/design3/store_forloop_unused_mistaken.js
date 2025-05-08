






for (const type of TypeNames_arr) {

            const TC = Design_TypeAll_objOfObj_initial[type].type_comment;
            const Code1 = Design_TypeAll_objOfObj_initial[type].type_code_studiedCurr;
            const Code2 = Design_TypeAll_objOfObj_initial[type].type_code_testiedCurr;
            const Code3 = Design_TypeAll_objOfObj_initial[type].type_code_testiedNext;
            const size_inList_inUnitScale_newInList = Design_TypeAll_objOfObj_initial[type].size_inList_inUnitScale_newInList ;
            const size_inList_inUnitScale_newPosFinal = ['f','r'].includes(condi) ? Design_TypeAll_objOfObj_initial[type].size_inList_inUnitScale_newPosFinal_f_r : Design_TypeAll_objOfObj_initial[type].size_inList_inUnitScale_newPosFinal_b ; //this line didn't consider conditions other than f, b, r; =[a,b,c] 3 elements array
            
            const nitem_list1 =  size_inList_inUnitScale_newInList[0] * n_itemInUnit_singular; //store for later easier use

            for (let i = 0; i < n_lists_singular; i++) {
                // Slice correct portion

                //The following step initialize the picNames_listi_typeX_initial array in making it have the correct number items and an id of each item of each list 
                // picNames_listi_typeX_initial
                let picNames_listi_typeX_initial;
                //Warning right here, check later if error
                if (i===0){ //list 1, special right here
                    picNames_listi_typeX_initial = picnames_rand_MasterPool_initial_obj_ofArr[type].slice(0, nitem_list1); //e.g. length 4 for Fn,  4 for A
                }else{
                    picNames_listi_typeX_initial = picnames_rand_MasterPool_initial_obj_ofArr[type].slice( nitem_list1 + (i-1)*size_inList_inUnitScale_newInList[1]*n_itemInUnit_singular, nitem_list1 + i*size_inList_inUnitScale_newInList[1]*n_itemInUnit_singular); //e.g. length 1 for Fn., 4 for A
                }
                
                
                
                let picNames_toPatch_listi_typeX;
                if (i===0){

                        picNames_toPatch_listi_typeX = picnames_rand_MasterPool_finalFoil_obj_ofArr_shallowCopy[type].splice(size_inList_inUnitScale_newPosFinal(0,size_inList_inUnitScale_newPosFinal[0]) ) //picname of length
                          
                }else if (i<(n_lists_singular-1)){//middle lists
                    picNames_toPatch_listi_typeX = picnames_rand_MasterPool_finalFoil_obj_ofArr_shallowCopy[type].splice(size_inList_inUnitScale_newPosFinal(0,size_inList_inUnitScale_newPosFinal[1]) );
                }else{//i=n_list_singular-1
                    picNames_toPatch_listi_typeX = picnames_rand_MasterPool_finalFoil_obj_ofArr_shallowCopy[type].splice(size_inList_inUnitScale_newPosFinal(0,size_inList_inUnitScale_newPosFinal[2]) );;
                };

                //Following are for picking the item used for final test
                const allIndices = Array.from({ length: picNames_toPatch_listi_typeX.length }, (_, inow) => inow);//give array of length n, array values to be inow (1 to n), bassically range(1,n)
                console.log("Indices:::",allIndices);

                // Shuffle the index array and pick first picNames_toPatch_listi_typeX
                const finalTestIndices = allIndices.sort(() => Math.random() - 0.5).slice(0, picNames_toPatch_listi_typeX);
                const chosenFinalSet = new Set(finalTestIndices);

                // console.log("type",type,"i",i)
                // console.log("listitems",picNames_listi_typeX_initial)
                // Map into objects
                // console.log("type",finalTestIndices,chosenFinalSet,picNames_listi_typeX_initial)
                const master_arrObj_typei_listi = picNames_listi_typeX_initial.map((id_picName, idx) => ({
                    type_comment: TC,
                    type_code_studiedCurr : Code1,
                    type_code_testiedCurr : Code2,
                    type_code_testiedNext : Code3,
                    id_picName: id_picName,
                    id_picDir: picdir + id_picName,
                    stimulusConditions : type, //condition for the whole exp, ABC, etc
                    wordcondi : condi,
                    anRepeatedItem: ['Cn','Dn','Fnn'].includes(type) ? true : false,
                    current_assignmentTypesWithinList: null,//T_target/T_foil/T_nontarget
                    listNum_firstAppear_initial: i+1,
                    listNum_finalOrder: null,
                    currentTask: null,//study/test
                    studyPos_appear1_initial: null,
                    testPos_appear1_initial: null,
                    is_studied_appear1_initial: null,
                    is_tested_appear1_initial: null,
                    studyPos_appear2_initial: null,
                    testPos_appear2_initial: null,
                    is_studied_appear2_initial: null,
                    is_tested_appear2_initial: null,
                    studyPos_appear0_initial: null,
                    testPos_appear0_initial: null,
                    is_studied_appear0_initial: null,
                    is_tested_appear0_initial: null,
                    is_currentObjAppear1: null,
                    num_CurrObjAppear: null,
                    testPos_final: null,//initialize to be 0
                    stimulusConditionName_nPlusOneTrial: null,//initialize to be 0
                    is_chosenFinal: chosenFinalSet.has(idx), //same above
                    listNum_currTest_initial: null,
                    is_old: null,
                    correct_response_key: null,
                    is_finalFoil: false
                }));

                master_obj_arr_arrObj_initial[type].push(master_arrObj_typei_listi);
                master_obj_arr_arrObj_initial[type].push(master_arrObj_typei_listi);
            };

        }