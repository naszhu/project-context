
if (num1 + num2 <= threshold) {
    throw new Error(`Error: Sum of ${num1} + ${num2} does not exceed ${threshold}.`);
    } else {
    console.log("Calculation passed.");
    }

const nextTestMap = new Map();
nextTestList.forEach((obj, idx) => {
    nextTestMap.set(obj.id_picName, obj);
});

const finalTestIndex_forward_arr = generateTestPositions(n_newInEachList_plusFinalFoil_inItemScale_final_arr);//e.g., [[2,1...] ,[14,11,...],]
const finalTestIndex_backward_arr = [...finalTestIndex_forward_arr].reverse();
const finalTestIndex_random_flat_arr = shuffledRange(n_itemFinalTest_singular)
const finalTestIndex_random_arr = n_newInEachList_plusFinalFoil_inItemScale_final_arr.reduce(
    ([res, i], size) => [ [...res, finalTestIndex_random_flat_arr.slice(i, i + size)], i + size ],
    [[], 0]
)[0]; //making the flat array to become a nested one like the two above

let finalTestIndex_arr;
//check the following if it assigns globally
if (condi==='f') finalTestIndex_arr = finalTestIndex_forward_arr;
if (condi==='b') finalTestIndex_arr = finalTestIndex_backward_arr;
if (condi==='r') finalTestIndex_arr = finalTestIndex_random_arr;

//
finalTestIndex_padWithMinusOne = finalTestIndex.map(arr =>
    padWithMinusOneRandomly(arr, n_imgperlist*2)
);;

// is_chosenFinal

const n_lists_singular = 10;//number of lists
const n_itemInUnit_singular = 3; //3 items in each category. This haven't been converge this var to Int
const n_itemInUnit_final_singular = n_itemInUnit_singular-1;//number

const n_NumAllUnit_exceptOverlapInCurrentList_InUnitScale_perList_singular =  15;//15 units of pictures used current list
const n_NumAllItem_exceptOverlapInCurrentList_InItemScale_perList_singular =  n_NumAllUnit_exceptOverlapInCurrentList_InUnitScale_perList_singular * n_itemInUnit_singular;//45 pictures used current list, regardless of from prior or not
const n_imageStudyOrTest_perList_inUnitScale_singular = n_NumAllUnit_exceptOverlapInCurrentList_InUnitScale_perList_singular * (2/3); // 10 unit of tests 
const n_imageStudyOrTest_perList_inItemScale_singular = n_imageStudyOrTest_perList_inUnitScale_singular*n_itemInUnit_singular; //30 tests
// (portion) of item used in each category
const finalTest_PortionItemUseInType_singular = 2/3; 
const n_howMuchMoreUnitSpecialForList1_inUnitScale_forFnn_forAll_singular = 3; //3 more units in list 1, and all that is from Fn; 
