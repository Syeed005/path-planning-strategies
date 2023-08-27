# Path Planning Strategies
This project is to implement two major operations: Clustering and Path Planning. Suppose there are 100 points of interest (POIs) that are non-uniformly distributed in a 1,000 x 1,000 (m2) network. The locations of POIs follow a scale-free property, where a group of POIs is located within a small area. A drone equipped with a sensor flies over the network and scans all POIs, in which a coverage radius of the sensor (r) is set to 100 (m), coverage range. In this project, a source code of scale-free will be provided to generate POIs.

First, cluster POIs using a neighbor density-based clustering algorithm to efficiently cover all POIs. The basic idea is to group densely populated POIs in an early stage and remove the number of candidate POIs to cover quickly. Please see the technical paper.

Second, the drone launches from the base, located left and bottom in the network (0, 0), and flies toward the center locations (scan points) of each coverage range to scan all POIs. In this project, path planning is to determine the sequence of visits on all scan points. (i) In RAND, the drone first flies toward any randomly selected scan point. Upon arrival, the drone flies toward another randomly selected scan point. The drone repeats the same procedure until visits all scan points. (ii) In NNF, the drone selects a scan point that is the closest located to the drone. Upon arrival, the drone selects another closest located scan point from the current scan point. The drone repeats the same procedure until visits all scan points. (iii) in DF, the drone selects the scan point that covers the most POIs. Upon arrival, the drone selects the scan point that covers the second most POIs. The drone repeats the same procedure until visits all scan points. 

# How to Run the Program
- Run the function with arguments like - path(0) e.g – 0 or 1 or 2
- 1st argument is for type. E.g- 0 for Rand, 1 for NNF, and 2 for DF-based path planning

# Generated Sample Graphs

- Clustering
  
 ![image](https://github.com/Syeed005/path-planning-strategies/assets/124804545/1f1f9ce0-5c5f-4fde-bb7e-8e6b51bf5e4a)

- Random Path Planning

  ![image](https://github.com/Syeed005/path-planning-strategies/assets/124804545/6291566d-cc85-4a50-bae7-e8a3a3ec8968)

- NNF Path Planning

  ![image](https://github.com/Syeed005/path-planning-strategies/assets/124804545/e694c1ba-7cd7-4f04-b77a-a4aef71d789e)

- DF Path Planning

  ![image](https://github.com/Syeed005/path-planning-strategies/assets/124804545/c02acea6-a5e8-405c-99a5-5c50b5a22373)



 
