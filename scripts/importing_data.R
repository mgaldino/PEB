library(googlesheets4)
library(tidyverse)
library(janitor)
library(lubridate)
gs4_auth()
abas <- sheet_names("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk")
print(abas)
dados12 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk",
                      sheet = "2012",  col_types = "c")

dados12 <- dados12 %>%
  clean_names() %>%
  filter(!is.na(de)) %>%
  mutate(data = dmy(data,  tz = "UTC")) %>%
  rename(de_para = de) %>%
  mutate(de_para = paste(de_para, para, sep="-")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )

dados13 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", sheet = "2013",
                      skip = 2,  col_types = "c")

dados13 <- dados13 %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  mutate(data = mdy(data,  tz = "UTC")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )

dados14 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", sheet = "2014",
                      skip = 1, col_types = "c")
dados14 <- dados14 %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  mutate(data = mdy(data,  tz = "UTC")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )


dados15a <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", 
                       sheet = "2014-2015", col_types = "c")

dados15a <- dados15a %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  mutate(data = mdy(data,  tz = "UTC")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )


dados15b <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", sheet = "2015-2016",
                       col_types = "c")
dados15b <- dados15b %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  mutate(data = mdy(data,  tz = "UTC")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )

dados16 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", sheet = "2016-2017")
dados16 <- dados16 %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  dplyr::select(no, tipo, de_para, resumo, data ) %>%
  mutate(no = as.character(no))

dados17 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk", sheet = "2017-2018")
dados17 <- dados17 %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  rename(no = numero,
         tipo = tipo_documento) %>%
  dplyr::select(no, tipo, de_para, resumo, data ) %>%
  mutate(no = as.character(no))

# Converte cada elemento: se já for POSIXct, transforma em string; senão, mantém
# Em seguida, interpreta as strings considerando os possíveis formatos


dados17 <- dados17 %>%
  mutate(data = parse_date_time(map_chr(data, as.character),
                                orders = c("ymd HMS", "ymd", "mdy HMS", "mdy"),
                                tz = "UTC"))



dados19 <- read_sheet("1qyRG6rzmjSrvakv2xruOQP7I67qnaFJcmV1Jv-EKkYk",
                      sheet = "2019-2020", col_types = "c")
dados19 <- dados19 %>%
  clean_names() %>%
  filter(!is.na(de_para)) %>%
  mutate(data = dmy(data,  tz = "UTC")) %>%
  dplyr::select(no, tipo, de_para, resumo, data )

cables <- bind_rows(dados12, dados13, dados14, dados15a, dados15b, dados16, dados17, dados19)
library(here)
write.table(cables, file=here("dados transformados","cables_reserved.csv"), sep=";", row.names=F)

# pra llm
# 200 linhas

# Número total de linhas
n <- nrow(cables)

# Cria um vetor de grupos: 7 grupos com 200 linhas e 1 grupo com o restante (204 linhas)
grupos <- rep(1:8, each = 200, length.out = n)

# Divide o data frame de acordo com os grupos
lista_cables <- split(cables, grupos)

# Salva cada parte em um arquivo CSV separado
map2(lista_cables, 1:8, ~ {
  arquivo <- here("dados transformados", paste0("cables_reserved_", .y, ".csv"))
  write.table(.x, file = arquivo, sep = ";", row.names = FALSE)
})
