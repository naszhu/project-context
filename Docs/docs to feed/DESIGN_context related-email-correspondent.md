


Why should performance in Experiment 2 be worse than in Experiment 1? We had discussed list length effects and weaker storage of targets. But----

In focusing on all the details of your Experiment 2 results, we entirely lost track of the big picture and what is of overriding importance: REM was developed for an experiment in which all items were taken from a common pool of items with similarity varying by sampling from a single g distribution and additional noise added by u and c. But now we have a different situation where the foils are not one kind but varying in their similarity. Simple REM cannot be used in its raw form for this case with a mixture of foils. To make the point clear, consider a simple situation with a single list of pictures of the same kind we use and 50% target tests, 50% foil tests. However on 99% of those foil tests we choose pictures that are almost identical to one of the pictures studied (so similar the S can't tell the difference). On 1% of the foil tests they are the usual 'new foils'. In such a study when a target is tested S will basically be guessing and be almost at chance. When a foil is tested only 1% of the time would S be able to be above chance. 

The point: When some foils become confusable with targets then of course performance will drop and a model would have to be able to take that into account. Simple REM does not do that. Thus of course we should expect performance in Experiment 2 to drop, and we need to adjust simple REM somehow to reflect the mixture of foil types in Experiment 2, especially if we are to compare the two studies.

I will have to think carefully about the best way to do this. If I come up with any good and simple ways to do this I'll let you know soon I hope.

Rich

---
Some initial thoughts.
There are 30 studies for exp2 and only 20 in exp 1, and there are also more tests in exp 2. In both experiments some tests will strengthen and reduce effective list length due to differentiation, but the large effect will be storage of new traces, making list length longer and increasing noise and confusion.
Will list length changes be enough to explain the lower performance levels in Exp 2? There are two kinds of performance that might be a good place to start thinking: In both studies:
In initial testing, items studied and tested (Hits) averaged with new foils (CRs).
In final testing, the same items that are now targets, and items initially studied only, (final Hits) both vs new foils (CRs).
I think the performance differences between the studies for comparable items are pretty large, so it is not clear of the ‘list length’ differences are enough to produce the performance differences.
I note that list 1 in Exp 2 is about 7% worse than Exp 1. That is presumably due to list length.
However, we have already decided that we want to explain changes in lists after the first by a shift in strategy such that less coding of content features starts happening with list two and continues until about list or so. That itself could make Exp 2 performance worse, and that would add to the list length effects.
If together these effects are insufficient, then what else? That is far from clear, but it is probably best not to think about it unless simulations who iit is needed.
---

Actually, TCM type context is indeed potentially important for our developing ideas and data concerning context in memory, but most relevant directly for you and Marc Howard is the idea that there is neural coding for time:

Lea's studies have 10 successive lists of pictures studied and tested for recognition, and then a final test in which every picture seen in the first ten study/test lists is a target and there are an equal number of new foils.  In study 1 all foils in the first ten lists are novel, but that does not necessarily force Ss to focus on the most recent list. In study 2, 4/5 of the foils in the first ten lists were seen on the prior trial (but not on the current study list), and are thus very confusing. The Ss begin by giving many false alarms to these confusing foils, but get better and better as the lists continue, presumably because they use increasingly better context to focus on the current list and thereby do not activate traces from the prior list.

We are dividing context features in our memory studies into those that change from one list to the next (termed CC) and those that stay the same from one list to the next (termed UC) It is the CC features that we believe Ss can encode better and use to discriminates successive lists in the first ten (final testing we assume uses mostly UC features to probe memory, but some CC features as well, to account for significant recency: The hits in final testing are at a higher level for pictures seen in the most recent lists. 

But what sort of features are CC features? What can change from one list to the next? One possibility is internal, what thoughts S has that change over time. Another possibility is the other items in each list, which is the kind of context related to TCM. A third possibility is time itself. There may be 'temporal features' (call them TF) that change as time passes. The neural coding of time may reflect such features and these might be distinct from the other two (or possibly not if top-down influences by other features alter the neural coding?. I expect you and Marc have some insights about this).

Thus we hope first to discuss with you and hopefully Marc to temporal coding as one component of CC features. Then second we can turn to what could be thought of as either content features or context features, the other items in each list.

Rich

---
# Dissertation Proposal:


Title: 
The Role of Context in Memory Storage and Retrieval:
Insights from Recognition and Recall Studies through Computational Modeling
Objectives:
    1. To investigate the role of context in memory storage and memory retrieval of events (i.e. episodic memory).
    2. To develop and refine a detailed computational model of event memory that will delineate the role of context.
    3. To produce a model, as simple as possible, that will capture the major patterns of performance accuracy from studies of recognition and cued recall. These patterns will include differences due to words and pictures, list length, primacy and recency, output interference, initial study and test versus end of session testing, serial position effects within list and list position effects within session and end of session, and differences due to presentation of context information.
Modeling objectives:
    1. The focus will be on variants of the REM model (Retrieving Effectively from Memory), because it has been the best simplest model of recognition memory for events. 
    2. REM was designed to produce optimal decisions for recognition of items studied on lists; the dissertation will explore its ability to predict cued recall.
    3. Other models will be discussed and to the extent possible compared to REM. 
    4. The primary goal will be prediction of the form of data patterns from many studies, not just predicting the results from our new studies quantitatively.  
Methodology: 
    1. Several lists of words and pictures are studied, each followed by tests of recognition, and in the case of words, followed by cued recall o recognition.
    2. At session end there will be tests of all items seen during session; these test will be recognition and in the case of words, recognition or cued recall.
    3. Some end of session tests will provide information about the list on which a test item might have been studied. Other end of session tests will not provide such information. 
Current Progress:
	Two studies using web participants have been completed thus far.
    • Study 1: Recognition for Pictures - Participants studied ten lists of twenty pictures, each followed by tests of ten targets (from the list just studied) and ten foils (not previously seen in the study). At end of session all pictures seen, studied only, tested only (i.e. foils), and studied and tested (i.e. targets) were tested as targets, mixed with an equal number of new foils. There were three conditions in final testing: 1) Pictures studied or tested in the initial lists (i.e. final targets) were mixed randomly with foils. 2) Pictures studied or tested in the initial lists (i.e. final targets) were tested in forward order of list occurrence, and participants were told which list before each block of 40 tests. 3) Pictures studied or tested in the initial lists (i.e. final targets) were tested in backward order of list occurrence, and participants were told which list before each block of 40 tests. 
    • Analysis of the results from Study 1 is mostly complete.
    • Modeling of Study 1: In progress: An extended REM model is being used to predict within list performance and between list performance during the study and testing of the initial ten lists, and final test performance for all conditions. The REM model is extended to include 1) a filter determining which memory traces are activated prior to application of regular REM; 2) context change during testing; 3) strengthening of certain traces during testing; 3) storage of new traces during testing; 4) differential context cues used in different conditions of final testing. 
    • Study 2: Cued Recall for Words - Participants studied ??? – [this needs to be described].
    • Analysis and modeling of study 1 is just starting.  
Plans for additional studies:
    1. Two conditions for word lists: 1) Initial testing will be cued recall and final testing by recognition; 2) initial testing will be recognition and final testing by cued recall. 
    2. In the course of modeling it may become clear that an additional study or studies is or are needed, and these might be carried out, but are not part of the present proposal.


