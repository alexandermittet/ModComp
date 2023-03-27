def simulation(root: int, graph: dict, alpha0, variance0, alpha, beta, variance) -> dict:
    """
    BFS
    returns z value for all 407 nodes
    """
    gene_lengths = {}
    
    z0 = max(np.random.normal(alpha0, np.sqrt(variance0)), 1)
    queue = [(root, z0)]

    while queue:
        # handle the next element in queue
        node, z = queue.pop(0)
        
        # set node in results in genelength z
        gene_lengths[node] = z
        
        # get all children for the node
        children = graph.get(node, [])

        if not children:
            continue
        else:
            # for all the children for this node calculate their z
            # since we know it's a tree, only the parent can have influence
            for child in children:
                id, t = child
                t = round(t, 3)
                
                # draw a sample
                mean = (alpha * t) + (beta * z)
                var = variance * t
                
                    
                cpd_z = max(np.random.normal(mean, np.sqrt(var)), 1)
                #print(f"id:{id}, t:{t}, var:{var}, std:{np.sqrt(var)}, mean:{mean}, cpd:{cpd_z}")
                #if id == 205:
                #    print(var)
                #    print(mean)
                #    print(cpd_z)
                # append child to queue
                queue.append((id, cpd_z))

    return gene_lengths


def n_simulations(n, root, graph, alpha0, variance0, alpha, beta, variance) -> tuple:
    """
    Returns results for X=X1 ... X204 n times, and y=Z0 n times s
    """
    X = np.empty((n, 204))
    Z = np.empty((n, 203))
    y = np.empty(n)
    
    for i in range(n):
        results = simulation(root=root, graph=graph, alpha0=alpha0, variance0=variance0, alpha=alpha, beta=beta, variance=variance)
        
        # extract the first 204 values from the dictionary and add them to X as a row
        row_X = [results[key] for key in range(1, 205)]
        row_Z = [results[key] for key in range(205, 408)]
        
        X[i] = np.array(row_X)
        Z[i] = np.array(row_Z)
        
        # extract the value associated with key 407, root= Z0, and add it to y
        y[i] = results[407]
        
    return X, y, Z
