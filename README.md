# Disk Utilization

## Overview
The disk utilization script retrieves disk utilization information for a specified storage path. It provides an alternative method to obtain disk utilization without relying heavily on the iostat command. The script calculates the utilization based on the difference in disk read/write counts, although it may have some margin of error compared to the accuracy of the iostat command.

## Usage
To use the script, follow these steps:

1. Make the script executable:

   ```
   chmod +x dutil.sh
   ```

2. Run the script:

   ```
   ./dutil.sh <store_path> <sampling_interval>
   ```


   Replace `<store_path>` with the desired storage path and `<sampling_interval>` with the desired sampling interval.

## Explanation
The script uses the iostat command to directly obtain disk utilization information or calculates it by comparing the difference in disk read/write counts. The resulting utilization is displayed as a percentage.

## Disk Utilization
> Percentage of CPU time during which I/O requests were issued to the device (band-width utilization for the device). Device saturation occurs when this value is close to 100%

Disk utilization refers to the extent to which a disk or storage device is being used or occupied by data and processes. It is typically measured as the percentage of time the disk is actively engaged in input/output (I/O) operations relative to the total available time. Higher utilization percentages indicate more active disk usage, while lower percentages suggest underutilization and available capacity.

Please note that the calculated utilization from the script may have some margin of error compared to the accuracy of the iostat command.

# How the util of iostat is computed?

> https://stackoverflow.com/questions/4458183/how-the-util-of-iostat-is-computed


```
busy = 100.0 * blkio.ticks / deltams; /* percentage! */
if (busy > 100.0) busy = 100.0;
```

```
double deltams = 1000.0 *
        ((new_cpu.user + new_cpu.system +
          new_cpu.idle + new_cpu.iowait) -
         (old_cpu.user + old_cpu.system +
          old_cpu.idle + old_cpu.iowait)) / ncpu / HZ;
```

```
blkio.ticks = new_blkio[p].ticks
                - old_blkio[p].ticks;
```


But, the script employs a simplified calculation method and does not consider the finer details such as deltatime calculation. Instead, it uses the sleep command to obtain two sets of values from /proc/diskstats and calculates the utilization based on the difference in io_ticks.

