library(data.table)
# library(pbmcapply)

path = "~/Downloads/FavorecidosGastos/"

files = list.files(path)
byCNPJ = files[grepl("CNPJ.csv",files)]
byCNAE = files[grepl("CNAE.csv",files)]
byNatureza = files[grepl("Natureza",files)]

fullPathCNPJ = paste0(path,byCNPJ)

readData = function(idx){
  rows = readLines(fullPathCNPJ[idx], encoding = "latin1")
  data = rbindlist(lapply(strsplit(rows, "\t"),function(x)as.data.table(t(x))), fill = T)
  
  rm(list = "rows")
  invisible(gc())
  
  names(data) = as.character(data[1])
  data = data[!1]
  data[, AnoMes := strsplit(byCNPJ[idx],"_")[[1]][1]]  
  data = unique(data, by = "CNPJ")
  
  return(data)
}

# ncores = detectCores() - 1
# listData = pbmclapply(seq_along(fullPathCNPJ), readData, mc.cores = ncores, ignore.interactive = T)
listData = lapply(seq_along(fullPathCNPJ), readData)
data = rbindlist(listData)

rm(list = "listData")
gc()

write.table(data, "~/Downloads/FavorecidosGastos/FavorecidosCompleto.txt",sep="\t",row.names = F, quote = T)

