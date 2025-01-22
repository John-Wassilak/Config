(setq my/rss-yt-prefix "https://www.youtube.com/feeds/videos.xml?channel_id=")

(setq my/rss-feed-list
  `(("https://stallman.org/rss/rss.xml" text)
    ("https://feeds.megaphone.fm/h3podcast" podcast);; h3 podcast
    (,(concat my/rss-yt-prefix "UC2EQzAewrC10KCDFSS4j-zA") video) ;; zig showtime
    (,(concat my/rss-yt-prefix "UCPD_bxCRGpmmeQcbe2kpPaA") video);; hot ones
    (,(concat my/rss-yt-prefix "UCzml9bXoEM0itbcE96CB03w") video) ;; dronebot
    (,(concat my/rss-yt-prefix "UC7Z1FTCdSln_qFKK95AWplw") video) ;; ogldev
    (,(concat my/rss-yt-prefix "UCkRmQ_G_NbdbCQMpALg6UPg") video) ;; parens
    (,(concat my/rss-yt-prefix "UCUyeluBRhGPCW4rPe_UvBZQ") video) ;; primetime
    (,(concat my/rss-yt-prefix "UC__auRZOSvg0mxYBPs3GWMQ") music) ;; talk
    (,(concat my/rss-yt-prefix "UCrDwWp7EBBv4NwvScIpBDOA") video) ;; anthropic
    (,(concat my/rss-yt-prefix "UCkkS9vuXcbxijUfoXft8x7w") music) ;; mike dawes
    (,(concat my/rss-yt-prefix "UCtyzzW6rIQiGP7gfGTXkhDw") music) ;; jellyroll
    (,(concat my/rss-yt-prefix "UCU7v5kTKdLacf5c4KeMempQ") music) ;; baker
    (,(concat my/rss-yt-prefix "UC1h3FZ8vCxViozCLT-C3loA") music) ;; moreno
    ("https://framatube.org/feeds/videos.xml?videoChannelId=333" video) ;; fsf?
    (,(concat my/rss-yt-prefix "UCFCDLnoNn3lDOFYglbsuSqA") music) ;; nickel creek
    (,(concat my/rss-yt-prefix "UCRCkL89mcxMETTcqou5o5ow") music) ;; thile
    (,(concat my/rss-yt-prefix "UCtMZP29LNEkI96ezw8I0eGw") music) ;; j lage
    (,(concat my/rss-yt-prefix "UCL-0gAth4u6Wp-9_98XU3nA") music) ;; t emmanuel
    (,(concat my/rss-yt-prefix "UCxKSQr1q0IL-Ps0ekPhDE4A") music) ;; punch brothers
    (,(concat my/rss-yt-prefix "UCz7eHJIOAAgIUxlE8iODk7w") music) ;; dawes
    (,(concat my/rss-yt-prefix "UCXgxNzAgZ1GExhTW4X1mUrg") music)  ;; rebillet
    (,(concat my/rss-yt-prefix "UCZIB_p5AgVVdxgkYWHeUy-Q") video) ;; aimee
    (,(concat my/rss-yt-prefix "UCJ0FbAfZ5x1_wv0QaveNYNA") music) ;; voyager aus
    (,(concat my/rss-yt-prefix "UC4USoIAL9qcsx5nCZV_QRnA") video) ;; idubbz
    (,(concat my/rss-yt-prefix "UCjETc3psT6i7B5z6S1Y3ojQ") video) ;; ham radio tube
    (,(concat my/rss-yt-prefix "UCEtB-nx5ngoNJWEzYa-yXBg") video) ;; film joy
    (,(concat my/rss-yt-prefix "UC6t5e6r-JEVoz_yn6SdvLRw") video) ;; jim hart
    (,(concat my/rss-yt-prefix "UC6biysICWOJ-C3P4Tyeggzg") video) ;; low level prog
    ("https://feeds.simplecast.com/kwWc0lhf" podcast) ;; hidden brain
    (,(concat my/rss-yt-prefix "UCiBhDA8lcKqzH-jqmElNUfg") music) ;; tigran
    (,(concat my/rss-yt-prefix "UC6jUsIEZ2F875OB2Be84cpA") video) ;; ampersand
    (,(concat my/rss-yt-prefix "UC28n0tlcNSa1iPe5mettocg") video) ;; voidzilla
    (,(concat my/rss-yt-prefix "UCsI_41SZafKtB5qE46WjlQQ") video) ;; becky stern
    (,(concat my/rss-yt-prefix "UC75oa16yMCJm-JM8e7W2c4Q") video) ;; broderick
    (,(concat my/rss-yt-prefix "UCpMEC_NiX1r503JISXQ-VKw") video) ;; mrporter
    (,(concat my/rss-yt-prefix "UCRXiA3h1no_PFkb1JCP0yMA") video) ;; vogue
    (,(concat my/rss-yt-prefix "UCsEukrAd64fqA7FjwkmZ_Dw") video) ;; gq
    (,(concat my/rss-yt-prefix "UCJquYOG5EL82sKTfH9aMA9Q") video) ;; beato
    (,(concat my/rss-yt-prefix "UCRTeNftWBh6ePpiqzyMNmFw") video) ;; tonebase
    (,(concat my/rss-yt-prefix "UCSE6yilNScIz1SLTNQvrXMw") video) ;; v piano
    (,(concat my/rss-yt-prefix "UCmGSJVG3mCRXVOP4yZrU1Dw") video) ;; johnny harris
    (,(concat my/rss-yt-prefix "UCSW5iY5oGJtx_E_IPFxDraQ") video) ;;art of st
    (,(concat my/rss-yt-prefix "UCd6qylQWz49LNjE4xrKf3RA") video) ;; prof simon holland
    (,(concat my/rss-yt-prefix "UCC2RJ3tINAiKEH9X_ijo1Yg") video) ;; kb9vbr
    (,(concat my/rss-yt-prefix "UCZJVGkUR2iZo32xCBBwb0lQ") video) ;; hv metal horizons
    (,(concat my/rss-yt-prefix "UCnRVL1-HJnXWB_Xi2dAoTcg") video) ;; brian johnaon
    (,(concat my/rss-yt-prefix "UCNY02mhMxIA401SzGixUgFw") video) ;;swingles
    (,(concat my/rss-yt-prefix "UCaTznQhurW5AaiYPbhEA-KA") video) ;; molly rocket
    (,(concat my/rss-yt-prefix "UCuxpxCCevIlF-k-K5YU8XPA") video) ;; scott kilmer
    (,(concat my/rss-yt-prefix "UCTl3QQTvqHFjurroKxexy2Q") video) ;;olympics
    (,(concat my/rss-yt-prefix "UCFQMnBA3CS502aghlcr0_aw") video) ;;coffeezilla
    (,(concat my/rss-yt-prefix "UCmv1CLT6ZcFdTJMHxaR9XeA") music) ;; pentatonix
    ("https://showrss.info/user/281395.rss?magnets=true&namespaces=true&name=null&quality=null&re=null" text) ;; tv show feed
    (,(concat my/rss-yt-prefix "UCVeW9qkBjo3zosnqUbG7CFw") video) ;; john hammond
    ("https://www.2600.com/rss.xml" podcast)
    (,(concat my/rss-yt-prefix "UC0cd_-e49hZpWLH3UIwoWRA") video) ;; prof dave
    (,(concat my/rss-yt-prefix "UCO3tlaeZ6Z0ZN5frMZI3-uQ") video) ;;obrien
    (,(concat my/rss-yt-prefix "UCM_qgRbk2J8tqlSX0HV58RA") video) ;;sco
    (,(concat my/rss-yt-prefix "UCVjlpEjEY9GpksqbEesJnNA") video) ;; uncle roger
    (,(concat my/rss-yt-prefix "UCY4oKJ57Dx3GITBbHkODlGw") video) ;; natty
    (,(concat my/rss-yt-prefix "UC9x0AN7BWHpCDHSm9NiJFJQ") video) ;; net chuck
    (,(concat my/rss-yt-prefix "UCUsCq3Hq5haa6tTph41hpJQ") video) ;; ecklund
    (,(concat my/rss-yt-prefix "UCtI0Hodo5o5dUb67FeUjDeA") video) ;; spacex
    (,(concat my/rss-yt-prefix "UCteFOtSvvbnceka5zKsHBYw") music) ;; maggie rogers
    (,(concat my/rss-yt-prefix "UCRLOLGZl3-QTaJfLmAKgoAw") video) ;; thrall
    (,(concat my/rss-yt-prefix "UCpMEC_NiX1r503JISXQ-VKw") video) ;; porter
    (,(concat my/rss-yt-prefix "UCi7nMpXuCXT_SUOOE6Yy2ag") video) ;; tom ford
    (,(concat my/rss-yt-prefix "UCnmGIkw-KdI0W5siakKPKog") video) ;; trahan
    (,(concat my/rss-yt-prefix "UCLA_DiR1FfKNvjuUpBHmylQ") video) ;; nasa
    (,(concat my/rss-yt-prefix "UC9ZKDGCc5R67fVvLFSv-OLA") video) ;; war poet
    (,(concat my/rss-yt-prefix "UCtPrkXdtCM5DACLufB9jbsA") video) ;; mrballen
    (,(concat my/rss-yt-prefix "UCRxt82qGgUASnftwSCQCWZw") video) ;; chenry
    (,(concat my/rss-yt-prefix "UCjiVhIvGmRZixSzupD0sS9Q") video) ;; noobs
    ("https://pluralistic.net/feed/" text) ;; doctoro
    ("https://martinfowler.com/bliki/bliki.atom" text)
    (,(concat my/rss-yt-prefix "UCKNVniNJKTYRZpTmfyJJjtA") video) ;; lavery
    (,(concat my/rss-yt-prefix "UCMrMVIBtqFW6O0-MWq26gqw") video) ;; my mechanics
    (,(concat my/rss-yt-prefix "UCl9OJE9OpXui-gRsnWjSrlA") video) ;; photon
    (,(concat my/rss-yt-prefix "UCtM5z2gkrGRuWd0JQMx76qA") video) ;; big clive
    (,(concat my/rss-yt-prefix "UC6EJTy6p58ZW16PEljSn4Qw") video) ;; t nagy
    (,(concat my/rss-yt-prefix "UC-gO6d2N_MiG5wVuL14okbg") video) ;; tkennedy
    (,(concat my/rss-yt-prefix "UCknfFAeVpD6e5-9wriAGVwg") music) ;; pickles
    (,(concat my/rss-yt-prefix "UCzS3-65Y91JhOxFiM7j6grg") video) ;; fod
    (,(concat my/rss-yt-prefix "UCPzyK7-vPvtWU5H4vjK1xjw") video) ;; amythyst
    (,(concat my/rss-yt-prefix "UCdKj0VzVR0Af0wzd7-68Avw") music) ;; tim henson
    (,(concat my/rss-yt-prefix "UCz__rO-DqQjGACVNvJJ8bKg") video) ;; mmf
    (,(concat my/rss-yt-prefix "UC4PziMH5MvvsmqM0VCZTy-g") video) ;; gnorton
    (,(concat my/rss-yt-prefix "UCytvslh5KzMrcaEQxDVrmAA") video) ;; joetroop
    (,(concat my/rss-yt-prefix "UCAiiOTio8Yu69c3XnR7nQBQ") video) ;; system crafters
    (,(concat my/rss-yt-prefix "UC5FaqTBy0c1jlRUHKu4SuXQ") video) ;; sstrength
    (,(concat my/rss-yt-prefix "UC6LntleHjrsHuh4QJmiVjNw") video) ;; rain country
    (,(concat my/rss-yt-prefix "UCVGVbOl6F5rGF4wSYS6Y5yQ") video) ;; mi garden
    (,(concat my/rss-yt-prefix "UCSbyncU597LMwb3HhnAI_4w") video) ;; epic garden
    (,(concat my/rss-yt-prefix "UCgfsZHnW6-6uMLmOGu824kQ") video) ;; epic home
    (,(concat my/rss-yt-prefix "UCjYun1PcC1l0Kq0x4h0mBFg") video) ;; am homestead
    (,(concat my/rss-yt-prefix "UCMIjEnXruVHtvgSVf6TgfUg") video) ;; wranglerstar
    ("https://www.fsf.org/static/fsforg/rss/news.xml" text)
    (,(concat my/rss-yt-prefix "UC5kS0l76kC0xOzMPtOmSFGw") video) ;; chess
    ("https://detentionfordefects.com/atom.xml" text)
    (,(concat my/rss-yt-prefix "UC6I0KzAD7uFTL1qzxyunkvA") video) ;; blacktail
    ("https://emacsconf.org/index.rss" text)
    ("https://feeds.feedburner.com/mrmoneymustache" text)
    ("https://100r.co/links/rss.xml" text)
    ("https://oklahomawatch.org/feed" text)
    (,(concat my/rss-yt-prefix "UCtMVHI3AJD4Qk4hcbZnI9ZQ") video) ;; mudahar
    (,(concat my/rss-yt-prefix "UC6nSFpj9HTCZ5t-N3Rm3-HA") video) ;; vsauce
    (,(concat my/rss-yt-prefix "UCGaVdbSav8xWuFWTadK6loA") video) ;; vlogbros
    (,(concat my/rss-yt-prefix "UC5UAwBUum7CPN5buc-_N1Fw") video) ;; linux exp
    (,(concat my/rss-yt-prefix "UCVls1GmFKf6WlTraIb_IaJg") video) ;; distrotube
    (,(concat my/rss-yt-prefix "UC5vaV7WOjz71AD7q5DM8m0Q") video) ;; room to grow
    (,(concat my/rss-yt-prefix "UCr9ib9quyHJkEchOck4PG2w") video) ;; mlhomestd
    (,(concat my/rss-yt-prefix "UCFhXFikryT4aFcLkLw2LBLA") video) ;; nile red
    (,(concat my/rss-yt-prefix "UCuT0B27AxYqCPWMJixOOnMQ") video) ;; segura
    (,(concat my/rss-yt-prefix "UCq8oBCFE3FKRETVzQKDvg_w") video) ;; yurt
    (,(concat my/rss-yt-prefix "UCiNr6FzQ-Kb4wNsLGBWXH5w") video) ;; hbiogascs
    (,(concat my/rss-yt-prefix "UC_2lbLBOxZpEDHLEzd1z9vQ") video) ;; homebiogas
    (,(concat my/rss-yt-prefix "UCtHaxi4GTYDpJgMSGy7AeSw") video) ;; reeves
    (,(concat my/rss-yt-prefix "UCQB4-ZjPDfiG1-k0KZlbPug") music) ;; thundercat
    (,(concat my/rss-yt-prefix "UCNypeTQAfb2pBA-BLPYK0kg") video) ;; linvega
    (,(concat my/rss-yt-prefix "UCPgJddP_Y3BHo_8bG0G1TCA") video) ;; Yanis
    (,(concat my/rss-yt-prefix "UCzdg4pZb-viC3EdA1zxRl4A") video) ;; 100r
    (,(concat my/rss-yt-prefix "UCehBVAPy-bxmnbNARF-_tvA") video);; more perfect union
    (,(concat my/rss-yt-prefix "UCuDv5p8E-evaRSh542hDV5g") video);; robert reich
    (,(concat my/rss-yt-prefix "UCxfgTxo6HUmnZkxHWFV5T-A") video);; stars
    (,(concat my/rss-yt-prefix "UC_GRMAkr6nIEx8smcOH1CNw") video);; 2600
    (,(concat my/rss-yt-prefix "UCvEpsAwbN4riDPgYcz9ED1Q") music);; dallas records
    (,(concat my/rss-yt-prefix "UC4eEWD0Emox6YOdaWVwmxAw") music);; let3
    (,(concat my/rss-yt-prefix "UCqs_rqwO2dUouMqh3ZLeBHw") music);; dora
    (,(concat my/rss-yt-prefix "UCwzAmROPHasu6Gof1I4qvYQ") video);; demange
    (,(concat my/rss-yt-prefix "UC3XTzVzaHQEd30rQbuvCtTQ") video);; last week tonight
    ("https://freepressokc.com/feed" text)
    (,(concat my/rss-yt-prefix "UCOVfq3NNYjlYCz1iou69FwQ") video);; kramling
    ("https://feeds.simplecast.com/Y8lFbOT4" podcast);; freakonomics pod
    ("https://googlecloudpodcast.libsyn.com/rss" podcast);; gcp pod
    ("https://serve.podhome.fm/rss/1c0357c0-6aba-5766-a2d5-2090d8dab6bc" podcast);; de podcast
    ("https://feeds.transistor.fm/the-data-engineering-show" podcast) ;; de show
    ("https://feeds.redcircle.com/64a89f88-a245-4098-8d8d-496325ec4f74" podcast) ;;jocko
    ("https://feeds.megaphone.fm/hubermanlab" podcast);; huberman
    ("https://www.omnycontent.com/d/playlist/e73c998e-6e60-432f-8610-ae210140c5b1/a91018a4-ea4f-4130-bf55-ae270180c327/44710ecc-10bb-48d1-93c7-ae270180c33e/podcast.rss" podcast);; stuff you should know

    ("https://feeds.simplecast.com/dHoohVNH" podcast);; conan
    (,(concat my/rss-yt-prefix "UCJHA_jMfCvEnv-3kRjTCQXw") video) ;; babish
    (,(concat my/rss-yt-prefix "UCpSgg_ECBj25s9moCDfSTsA") video) ;; joliver
    (,(concat my/rss-yt-prefix "UC1KsxDW7hhfeq5QQmFtInIw") video) ;; julien
    ("https://www.omnycontent.com/d/playlist/e73c998e-6e60-432f-8610-ae210140c5b1/cf0c25ad-cf01-4da5-ae1c-b0fc015f790e/53ed270b-7147-4f70-81c2-b0fc015fe4ed/podcast.rss" podcast);; better offiline
    ("https://rss.nytimes.com/services/xml/rss/nyt/World.xml" text)
    ("https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml" text)
    ("https://worldstarhiphop.com/videos/rss.php" video)
    (,(concat my/rss-yt-prefix "UCRpjHHu8ivVWs73uxHlWwFA") music);; eurovision
    (,(concat my/rss-yt-prefix "UCF18N219OPiOcElz_hSYoIQ") music);; dadi
    (,(concat my/rss-yt-prefix "UCLG7twDweqlHpyv0EDOjrgw") music);; sigrid
    (,(concat my/rss-yt-prefix "UCNjHgaLpdy1IMNK57pYiKiQ") music);; aurora
    (,(concat my/rss-yt-prefix "UCPJFvbf8tNE9-_aYgeXfdKA") music);; daigle
    (,(concat my/rss-yt-prefix "UCGmtDrMebeJCq2jgvboJ7Jg") music);; needtobreathe
    (,(concat my/rss-yt-prefix "UCYp3rk70ACGXQ4gFAiMr1SQ") music);; rammstein
    (,(concat my/rss-yt-prefix "UCkjot4p29KLU0pwc0srHeGg") music);; t lindemann
    (,(concat my/rss-yt-prefix "UCbQporZxQlCjFDcxrWUX7BA") music);; lindemann
    (,(concat my/rss-yt-prefix "UCHcb3FQivl6xCRcHC2zjdkQ") music);; oliver tree
    (,(concat my/rss-yt-prefix "UCtpiIBHg_cbAIm9N-7SabOw") music);; metronomy
    (,(concat my/rss-yt-prefix "UCJMrvlVhrZYgP0MVoAUG1rw") music);; gund
    (,(concat my/rss-yt-prefix "UCG3hX4KkT3-vtLWLVg6hoeQ") music);; gund vevo
    (,(concat my/rss-yt-prefix "UCNa3uC5LqiRHOnv5b4MZ36g") music);; dead oceans
    (,(concat my/rss-yt-prefix "UCO76MEWSSwLR9cKvFXwh1vA") music);; bridgersVevo
    (,(concat my/rss-yt-prefix "UCh4PO1W9tVmHujIPZnfK8TQ") music);; bridgers
    (,(concat my/rss-yt-prefix "UCwWhs_6x42TyRM4Wstoq8HA") video);; daily show
    (,(concat my/rss-yt-prefix "UCsvn_Po0SmunchJYOWpOxMg") video);; dunkey
    (,(concat my/rss-yt-prefix "UCtmY49Zn4l0RMJnTWfV7Wsg") music);; jcollier
    (,(concat my/rss-yt-prefix "UCigygyPkHm07o-wQvkET7Og") music);; gcollier
    (,(concat my/rss-yt-prefix "UC4ihNhN8iN9QPg2XTxiiPJw") video);; score
    (,(concat my/rss-yt-prefix "UC4PIiYewI1YGyiZvgNlJNrA") video);; cornell
    (,(concat my/rss-yt-prefix "UCsN32BtMd0IoByjJRNF12cw") video);; 60 mins
    (,(concat my/rss-yt-prefix "UCq6VFHwMzcMXbuKyG7SQYIg") video);; charlie
    (,(concat my/rss-yt-prefix "UC-lHJZR3Gqxm24_Vd_AJ5Yw") video);; pew
    (,(concat my/rss-yt-prefix "UCJ0-OtVpF0wOKEqT2Z1HEtA") video);; medhi
    (,(concat my/rss-yt-prefix "UCs6KfncB4OV6Vug4o_bzijg") video);; techlore
    (,(concat my/rss-yt-prefix "UCsS3BCdeS_6wbclEfQ2jgqw") video);; dixon
    (,(concat my/rss-yt-prefix "UC0w4AA42ItXQEb9aZld87-w") video);; neg
    (,(concat my/rss-yt-prefix "UCQHX6ViZmPsWiYSFAyS0a3Q") video);; gotham
    (,(concat my/rss-yt-prefix "UCgH8NCuYcVzxxrfsrBj1u3A") video);; hawkins
    (,(concat my/rss-yt-prefix "UCy0tKL1T7wFoYcxCe0xjN6Q") video);; tech con
    (,(concat my/rss-yt-prefix "UC8R8FRt1KcPiR-rtAflXmeg") video);; nahre
    (,(concat my/rss-yt-prefix "UCaHT88aobpcvRFEuy4v5Clg") video);; limc
    (,(concat my/rss-yt-prefix "UCbrPqq29C9Q_TQP7OFFRzcw") video);; know your meme
    (,(concat my/rss-yt-prefix "UC3KEoMzNz8eYnwBC34RaKCQ") video);; giertz
    (,(concat my/rss-yt-prefix "UC6107grRI4m0o2-emgoDnAA") video);; smarter e day
    (,(concat my/rss-yt-prefix "UCpIafFPGutTAKOBHMtGen7g") video);; gus johnson
    (,(concat my/rss-yt-prefix "UC9-y-6csu5WGm29I7JiwpnA") video);; computerphile
    (,(concat my/rss-yt-prefix "UChAu6Cof9KlfFxSbL9ytosQ") video) ;; ham cc
    (,(concat my/rss-yt-prefix "UCcj3FycZBXIPNj7QIBKTIDw") video) ;; fc survival
    (,(concat my/rss-yt-prefix "UCi8C7TNs2ohrc6hnRQ5Sn2w") video) ;; program also human
    (,(concat my/rss-yt-prefix "UCnZx--LpG2spgmlxOcC-DRA") video) ;; thrasher
    (,(concat my/rss-yt-prefix "UCc80w2gBc1lbalveNDF642g") video) ;; mike glover
    (,(concat my/rss-yt-prefix "UCS7kyY9hqClnfIYreR5xvpg") video) ;; grunt proof
    (,(concat my/rss-yt-prefix "UCSF08irENp73EwqJ42rCsIQ") video) ;; grey beard green beret
    (,(concat my/rss-yt-prefix "UCtmkjheVeJC_1F_OeuX-hoA") video) ;; cam hanes
    (,(concat my/rss-yt-prefix "UCBvnS6nyNGAl8EUNt-40xoQ") video) ;; josh bridges
    (,(concat my/rss-yt-prefix "UCZeBmj9_UNMoqDHSO7QtzXg") video) ;; notarubicon
    (,(concat my/rss-yt-prefix "UC8DyQ6UyChGmJwA-NoUC0rA") video) ;; the-builder
    (,(concat my/rss-yt-prefix "UCrqM0Ym_NbK1fqeQG2VIohg") video) ;; tsoding daily
    (,(concat my/rss-yt-prefix "UCEbYhDd6c6vngsF5PQpFVWg") video) ;; tsoding
    (,(concat my/rss-yt-prefix "UCgBVkKoOAr3ajSdFFLp13_A") video) ;; krazam
    (,(concat my/rss-yt-prefix "UCdjfMYy2FgLRui9zUb7ZKUw") video) ;; jocko fuel
    (,(concat my/rss-yt-prefix "UCdC0An4ZPNr_YiFiYoVbwaw") video))) ;; daily

(use-package elfeed
  :custom
  (elfeed-db-directory "~/.elfeed")
  (elfeed-feeds my/rss-feed-list)
  (elfeed-curl-max-connections 1) ;; avoid 500s by going one-at-a-time
  (url-queue-timeout 30)
  :config
  (setq elfeed-log-level 'warn)
  (my/set-24hr-timer "01:00am" 'elfeed-update))

(require 'elfeed)
;;(async-shell-command (format "yt-dlp %s -o - | mpv -" url)))

(defun elfeed-v-mpv (url title)
  (call-process-shell-command
   (format "/mnt/crypt/john/yt-dlp/yt-dlp.sh %s -o - | mpv --title=\"%s\" - &" url title) nil 0))

(defun my/elfeed-view-mpv (&optional use-generic-p)
  (interactive "P")
  (let ((link (elfeed-entry-link elfeed-show-entry))
        (title (elfeed-entry-title elfeed-show-entry)))
    (when link
      (elfeed-v-mpv link title))))

(defun my/elfeed-dl-share (&optional use-generic-p)
  (interactive "P")
  (let ((link (elfeed-entry-link elfeed-show-entry)))
    (when link
      (dl-share link))))

(define-key elfeed-show-mode-map (kbd "v") 'my/elfeed-view-mpv)
(define-key elfeed-show-mode-map (kbd "s") 'my/elfeed-dl-share)

;; eww

;; stream url under point
;; (defun my/stream-point-url (url)
;; (interactive (list (shr-url-at-point current-prefix-arg)))
;; (stream url))

;; ;; dl
;;url under point
;; (defun my/eww-dl-share (url)
;; (interactive (list (shr-url-at-point current-prefix-arg)))
;; (dl-share url))

;; ;;(define-key eww-mode-map (kbd "m") 'my/stream-point-url)
;; (define-key eww-mode-map (kbd "s") 'my/eww-dl-share)

(defun my/elfeed-save-podcast (&optional use-generic-p)
  (interactive "P")
  (let ((link  (elfeed-entry-link elfeed-show-entry))
        (title (elfeed-entry-title elfeed-show-entry))
        (date  (format-time-string "%a, %e %b %Y %T %z" (elfeed-entry-date elfeed-show-entry)))
        (content (car (car (elfeed-entry-enclosures elfeed-show-entry)))))
    (when content
      (f-append (format "%s|%s|%s\n" title date content) 'utf-8 "/mnt/crypt/john/podcast/podcast_data"))))
