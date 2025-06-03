# **Project-Context**

This repository serves as the central hub for the research and development of various experimental designs. It contains documentation, data, analysis scripts, and experimental code related to the project.

## **📜 About This Project**

Project-Context is a comprehensive repository that tracks the evolution of multiple design iterations. It includes everything from initial design documents and literature reviews to the data, modeling, and front-end user interface experiments. The project is currently in an active development phase, with a significant focus on design3.

This repository is organized to keep track of the different design phases and their associated files. It also serves as a parent repository for more specialized, in-depth repositories like the one for the Design 3 model.

## **📂 Folder Structure**

The repository is organized into several key directories. The structure is laid out to separate each design iteration while maintaining a consistent sub-folder organization, as shown below:

* .  
  * Docs/  
  * IRB FOR ALL/  
  * papers/  
  * design1/  
    * data/  
    * data\_analysis/  
    * modeling/  
    * ui\_experiment/  
  * design2/  
    * ... (similar structure to design1)  
  * design3/  
    * data/  
    * data\_analysis/  
    * modeling/ \-\> (This links to the Child Repo: rem\_e3\_model\_fixed)  
    * ui\_experiment/  
  * exp\_host/  
    * main/  
    * functions/  
    * ...  
  * ... (other miscellaneous files and deprecated folders)

### **Core Directories**

* **Docs**: Contains important project documentation, including daily logs, meeting notes, and detailed explanations of the various design models.  
* **IRB FOR ALL**: This folder holds files related to the Institutional Review Board (IRB) approval for this research.**⚠️ Privacy Note:** Please be aware that IRB documents can sometimes contain sensitive information. It is crucial to ensure that no private or confidential data is publicly exposed in this repository. You may want to consider making this repository private or storing these documents elsewhere.  
* **papers**: A collection of academic papers and related literature that inform the research and design process.  
* **design1, design2, design3**: These are the main folders for each major design iteration. Each typically contains the necessary assets for that specific design, including:  
  * data/: Raw and processed data. The data/backup subfolder, if present, is a temporary holding area.  
  * data\_analysis/: Scripts and notebooks for analyzing the collected data.  
  * modeling/: Code and models related to the design.  
  * ui\_experiment/: Contains the front-end code for the experiment. The HTML files within the design folders are typically older, monolithic versions.  
* **exp\_host**: This directory contains the most current, modularized version of the Design 3 experiment. The code here is separated into logical modules (e.g., main.js, functions.js) for better maintainability, unlike the older HTML versions in the designX/ui\_experiment/ folders.

### **Deprecated Folders**

Folders such as design3- (with a trailing hyphen), data-design3, and Repeated Files are outdated and contain remnants of older file structures. They should be ignored as the relevant files have been migrated to the appropriate design folders.

## **🔗 Child Repositories**

This repository contains links to other specialized repositories.

* The modeling work for design3 is managed in a separate child repository: **rem\_e3\_model\_fixed**. This is conceptually linked from the design3/modeling/ directory.

## **🐛 Issue Tracking**

The project currently has a number of open issues listed in the repository's "Issues" tab. A significant portion of these issues pertain to **Design 3**. Additionally, many more issues are tracked within the child repositories, especially for the design3 model.

It's important to note that the project's contribution activity graph indicates that formal tracking of issues, commits, and model versions began relatively recently (around early May). Any development history, model versions, or issues prior to this date have not been formally logged or committed to this repository.

## **©️ Commit Style Convention**

To maintain a clear and organized version history, the project follows a consistent commit style, which can be observed in the repository's commit log. The format for commit messages is:

**type(scope): message**

For example: docs(model-e3): add doc related pic ... or fix(model): nC\_f and its Related Calculation .......

* **type**: Describes the kind of change (e.g., feat for a new feature, fix for a bug fix, docs for documentation, style, refactor).  
* **scope**: Specifies the part of the project being affected (e.g., model, model-d1, model-e3, all).  
* **message**: A concise description of the changes made.

## **🚀 Versioning and Deployment**

Currently, all development and commits are pushed directly to the main branch. There are no official tagged versions or releases published in this parent repository.

Stable, runnable versions of the experiments, particularly for Design 3, are intended to be tagged and published as releases in its dedicated child repository, **rem\_e3\_model\_fixed**.
