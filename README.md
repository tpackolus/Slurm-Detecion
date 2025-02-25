
### **README: Python Process Monitoring in Slurm and Non-Slurm Environments**

#### **Overview**

This Bash script monitors **Python processes** running both **inside Slurm jobs** and **outside of Slurm**. The results are displayed in the terminal and logged in **`slurm.txt`** for further analysis.

### **Functionality**

1.  **Identifies Python Processes Running in Slurm**
    
    -   Detects Python processes executed within Slurm jobs (`sbatch`, `srun`).
    -   Captures process details such as **PID, user, runtime, and command**.
    -   If a user has multiple processes, it shows **one example** and the **total count**.
2.  **Identifies Python Processes Running Outside Slurm**
    
    -   Detects Python processes that were launched manually (not via Slurm).
    -   Displays the **total number of processes per user** and **one sample process**.
3.  **Summarizes Results**
    
    -   **Inside Slurm:** Displays the number of processes per user and an example.
    -   **Outside Slurm:** Displays the number of processes per user and an example.
    -   **Logs all details into `slurm.txt`** for full reference.


```
============================================
        Python Processes in Slurm
============================================

============================================
    Python Processes Outside Slurm
============================================
No Python processes running outside Slurm.

============================================
    Summary of Processes in Slurm
============================================
[dh343ko] Running 3 Slurm processes | Example: [dh343ko] PID: 1698127 | Running Time: 01:27:04 | python lm-eval...
[mg873uh] Running 135 Slurm processes | Example: [mg873uh] PID: 1750341 | Running Time: 52:36 | python train.py...

============================================
    Summary of Processes Outside Slurm
============================================
No Python processes running outside Slurm.
```

### **✅ Script Features**

✔ **Automatically detects Python processes inside and outside Slurm**  
✔ **Summarizes the number of processes per user**  
✔ **Logs full details into `slurm.txt`**  
✔ **Can be run automatically every X seconds**


I would greatly appreciate any further improvements to the script and suggestions that enhance its functionality, especially in detecting a broader range of services running outside of Slurm. Any feedback or contributions that help make the script more robust and efficient are more than welcome! 🚀😊
