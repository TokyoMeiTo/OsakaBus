DELETE FROM MSTT01_LINE WHERE 1=1;

INSERT INTO MSTT01_LINE
 (LINE_ID,LINE_METRO_ID,LINE_METRO_ID_FULL,LINE_NAME,LINE_NAME_KANA,LINE_NAME_ROME,LINE_NAME_EXT1 ,LINE_NAME_EXT2 ,LINE_NAME_EXT3,LINE_NAME_EXT4,LINE_NAME_EXT5,LINE_NAME_EXT6,LINE_LON,LINE_LAT,LINE_PREF,LINE_COMP)
VALUES
('28001','Ginza','TokyoMetro.Ginza','銀座線','ぎんざせん','GinzaSen','银座线','LINE_28001','yinzuoxian','yzx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28002','Marunouchi','TokyoMetro.Marunouchi','丸ノ内線','まるのうちせん','MarunouchiSen','丸之内线','LINE_28002','wanzhineixian','wznx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28003','Hibiya','TokyoMetro.Hibiya','日比谷線','ひびやせん','HibiyaSen','日比谷线','LINE_28003','ribiguxian','rbgx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28004','Tozai','TokyoMetro.Tozai','東西線','とうざいせん','TozaiSen','东西线','LINE_28004','dongxixian','dxx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28005','Chiyoda','TokyoMetro.Chiyoda','千代田線','ちよだせん','ChiyodaSen','千代田线','LINE_28005','qiandaitianxian','qdtx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28006','Yurakucho','TokyoMetro.Yurakucho','有楽町線','ゆうらくちょうせん','YurakuchoSen','有乐町线','LINE_28006','youletingxian','yltx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28008','Hanzomon','TokyoMetro.Hanzomon','半蔵門線','はんぞうもんせん','HanzomonSen','半藏门线','LINE_28007','banzangmenxian','bzmx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28009','Namboku','TokyoMetro.Namboku','南北線','なんぼくせん','NambokuSen','南北线','LINE_28008','nanbeixian','nbx',NULL,NULL,NULL,NULL,NULL,NULL)
,('28010','Fukutoshin','TokyoMetro.Fukutoshin','副都心線','ふくとしんせん','FukutoshinSen','副都心线','LINE_28009','fuduxinxian','fdxx',NULL,NULL,NULL,NULL,NULL,NULL)
,('99301','Oedo',NULL,'都営大江戸線','とえいおおえどせん','OedoSen','都营大江户线','LINE_99301','duyingdajianghuxian','dydjhx',NULL,NULL,NULL,NULL,NULL,NULL)
,('99302','Asakusa',NULL,'都営浅草線','とえいあさくさせん','AsakusaSenn','都营浅草线','LINE_99302','duyingqiancaoxian','dyqcx',NULL,NULL,NULL,NULL,NULL,NULL)
,('99303','Mita',NULL,'都営三田線','とえいみたせん','MitaSen','都营三田线','LINE_99303','duyingsantianxian','dystx',NULL,NULL,NULL,NULL,NULL,NULL)
,('99304','Shijuku',NULL,'都営新宿線','とえいしんじゅくせん','ShijukuSen','都营新宿线','LINE_99304','duyingxinsuxian','dyxsx',NULL,NULL,NULL,NULL,NULL,NULL)
;