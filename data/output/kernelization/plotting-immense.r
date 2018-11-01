options("width"=230)
library(dplyr)

# Some variables that are used in various ways, to construct the plots
res_folder="./"
col_vec = c("darkorange","red2","dodgerblue2","black", "purple")
pnt_vec = c(9,16,17,15,0)
columns  <- c('#sec','#it','#|V(G)|','#|E(G)|','#|V(Gk)|','#|E(Gk)|','#|Erem|','#CUTDIFF','#MQLIB(G)','#MQLIB(G)+DIFF','#locsearch(G)','#locsearch(Gk)+DIFF','#EE(G)','#EE(Gk)', '#ktime', '#file')
 


#Need readjustment for each case:
x_start <- 15
x_start_legend <- 9
case_type <- "ba_1024"
nam_vec = c("GNM","RGG2D","RGG3D","BA","RHG")#, "original", "task a", "task b", "task c")
                                                            
# Read the results from the csv files
data_table  <- read.table(paste(res_folder, "out"     , sep=""), comment.char = "#", col.names = columns)
#base_raw <- read.table(paste(res_folder, "hash_original.txt", sep=""), comment.char = "#", col.names = columns)
#a_raw    <- read.table(paste(res_folder, "hash_a.txt"       , sep=""), comment.char = "#", col.names = columns)
#b_raw    <- read.table(paste(res_folder, "hash_b.txt"       , sep=""), comment.char = "#", col.names = columns)
#c_raw    <- read.table(paste(res_folder, "hash_c.txt"       , sep=""), comment.char = "#", col.names = columns)

data_table$ratio_e = 1 - (data_table[,"X..E.Gk.."]/data_table[,"X..E.G.."])
data_table$density = data_table[,"X..E.G.."]/data_table[,"X..V.G.."]
#data_table[,"X..E.G.."] <- log(data_table[,"X..E.G.."] , 2)

data_table <- data_table[with(data_table, order(X.sec,density)), ]
#print(data_table)


# Open a PDF to store the plot into
pdf("plot.pdf", width=10, height=5)

print(data_table[,"X..V.G.."])
#print(data_table);
print(paste("KEY:", getkey(0,data_table)))

v_count <- data_table[,"X..V.G.."][1]
print(v_count)

for (entry in list(
    c("ratio_e", paste("Kernelization efficiency for KaGen graph instances", sep="")
    ))) {
    
    # Here we choose the two comlumns, that we use for the plot
    y=entry[1]
    x="density"

    # Define some ranges for our plotting area
    xrange <- range(x_start,data_table[,x])
    yrange <- range(0, data_table[,y])
    yrange[2] <- yrange[2] * 1.1
    print(yrange)
    # Initialize the plotting area
    plot(xrange, yrange, yaxs='i', col="black", type="n", main="stuff", ann=FALSE)

    # Label titles for both axes
    title(xlab="Graph density: |E| / |V|"     , line=2.3)
    title(ylab="kernelization efficiency:  1 - |E(G')| / |E(G)|", line=2.3)
    title(main=entry[2])

    # Draws the 4 lines of measurements
    for (dx in c(1,2,3,4,5)) {
       sub <- dplyr::filter(data_table, X.sec == dx - 1)
       points(sub[,x] , sub[,y] , col=col_vec[[dx]], pch=pnt_vec[[dx]])
    }
    # Shows the legend
    legend(x_start_legend, yrange[2], nam_vec, lty=, col=col_vec, pch=pnt_vec)
}



# Closes the PDF
dev.off()