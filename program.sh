#!/bin/bash

# Define log file
LOG_FILE="slurm.txt"

# Start fresh log file
echo "============================================" > $LOG_FILE
echo "        Python procesy v Slurm-e" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE

# Create associative arrays for Slurm and non-Slurm processes
declare -A slurm_count
declare -A non_slurm_count
declare -A slurm_example
declare -A non_slurm_example

# Check Slurm processes
found_slurm=0
while read -r user pid etime cmd; do
    if [[ -n "$pid" && -e /proc/$pid/cgroup ]]; then
        if grep -q "slurm" /proc/$pid/cgroup 2>/dev/null && cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | grep -q "SLURM_JOB_ID"; then
            found_slurm=1
            echo "[$user] PID: $pid | Running Time: $etime | $cmd" >> $LOG_FILE
            slurm_count["$user"]=$((slurm_count["$user"] + 1))
            if [[ -z "${slurm_example[$user]}" ]]; then
                slurm_example[$user]="[$user] PID: $pid | Running Time: $etime | $(echo $cmd | cut -d' ' -f1-6)..."
            fi
        fi
    fi
done < <(ps -eo user:20,pid,etime,cmd --sort=start_time | grep -E "python|jupyter" | grep -v "grep")

if [[ $found_slurm -eq 0 ]]; then
    echo "Žiadne Python procesy bežiace cez Slurm" | tee -a $LOG_FILE
fi

echo "" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE
echo "    Python procesy mimo Slurm-u" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE

# Check non-Slurm processes
found_non_slurm=0
while read -r user pid etime cmd; do
    if [[ -n "$pid" && -e /proc/$pid/cgroup ]]; then
        if ! (grep -q "slurm" /proc/$pid/cgroup 2>/dev/null && cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | grep -q "SLURM_JOB_ID"); then
            if [[ "$cmd" =~ python[0-9]*\ .+\.py ]] || [[ "$cmd" =~ ipykernel_launcher ]] || [[ "$cmd" =~ jupyter ]]; then
                found_non_slurm=1
                echo "[$user] PID: $pid | Running Time: $etime | $cmd" >> $LOG_FILE
                non_slurm_count["$user"]=$((non_slurm_count["$user"] + 1))
                if [[ -z "${non_slurm_example[$user]}" ]]; then
                    non_slurm_example[$user]="[$user] PID: $pid | Running Time: $etime | $(echo $cmd | cut -d' ' -f1-6)..."
                fi
            fi
        fi
    fi
done < <(ps -eo user:20,pid,etime,cmd --sort=start_time | grep -E "python|jupyter" | grep -v "grep")

if [[ $found_non_slurm -eq 0 ]]; then
    echo "Žiadne Python procesy mimo Slurm-u" | tee -a $LOG_FILE
fi

echo "" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE
echo "    Súhrn procesov v Slurm-e" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE

# Display summary of Slurm users
for user in "${!slurm_count[@]}"; do
    if [[ ${slurm_count[$user]} -gt 1 ]]; then
        echo "[$user] Má spustených ${slurm_count[$user]} Slurm procesov | Ukážka: ${slurm_example[$user]}" | tee -a $LOG_FILE
    else
        echo "${slurm_example[$user]}" | tee -a $LOG_FILE
    fi
done

echo "" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE
echo "    Súhrn procesov mimo Slurm-u" | tee -a $LOG_FILE
echo "============================================" | tee -a $LOG_FILE

# Display summary of non-Slurm users
for user in "${!non_slurm_count[@]}"; do
    if [[ ${non_slurm_count[$user]} -gt 1 ]]; then
        echo "[$user] Má spustených ${non_slurm_count[$user]} procesov mimo Slurm-u | Ukážka: ${non_slurm_example[$user]}" | tee -a $LOG_FILE
    else
        echo "${non_slurm_example[$user]}" | tee -a $LOG_FILE
    fi
done
