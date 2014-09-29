DELETE FROM INFT03_RESCURE WHERE 1=1;

INSERT INTO INFT03_RESCURE
 (RESC_ID,RESC_LOCA,RESC_TYPE,RESC_CONTENT_CN,RESC_CONTENT_JP,READ_FLAG,READ_TIME,FAVO_FLAG,FAVO_TIME)
VALUES
('1','55','游览','在这地图上，我现在的位置在哪里？','この地図で現在地はどこですか','0',NULL,'0',NULL)
,('2','55','游览','这是去XX的路吗？','この道は～（どこどこ）に行きますか','0',NULL,'0',NULL)
,('3','5','游览','去XX怎么走？','～（どこどこ）へはどう行けば良いですか','0',NULL,'0',NULL)
,('4','5','游览','从这里到那里要多久？','ここからどれくらい（時間）かかりますか','0',NULL,'0',NULL)
,('5','5','游览','这里需要买门票吗？','入園券が要るか','0',NULL,'0',NULL)
,('6','5','游览','这里可以拍照吗？','ここで写真撮ってもいいですか','0',NULL,'0',NULL)
,('7','5','游览','想在这里拍个照，麻烦您啦。','ここで写真を撮りたいですが、ちょっとお願いします。','0',NULL,'0',NULL)
,('8','5','游览','特产店在哪？','お土産の店はどこですか？','0',NULL,'0',NULL)
,('9','5','游览','洗手间在哪？','お手洗いはどこですか？','0',NULL,'0',NULL)
,('10','5','游览','有会讲中国话的人吗？','中国語を話せる人はいませんか。','0',NULL,'0',NULL)
,('11','5','购物','这个多少钱？','これいくらですか','0',NULL,'0',NULL)
,('12','5','购物','请给我这个东西','これをください','0',NULL,'0',NULL)
,('13','5','购物','这个东西不是太喜欢','あまり気に入らないんですが','0',NULL,'0',NULL)
,('14','5','购物','可以试一下衣服吗？','着てみてもいいですか。','0',NULL,'0',NULL)
,('15','5','购物','太大了。','大きすぎます。','0',NULL,'0',NULL)
,('16','5','购物','太小了。','小さすぎます。','0',NULL,'0',NULL)
,('17','5','购物','有其他颜色吗？','他の色はありませんか。','0',NULL,'0',NULL)
,('18','5','购物','试衣间在哪里呢？','試着室はどこですか。','0',NULL,'0',NULL)
,('19','5','购物','有折扣吗？','割引はありませんか。','0',NULL,'0',NULL)
,('20','5','饮食','请给我X人的座位','X名です。','0',NULL,'0',NULL)
,('21','5','饮食','要等几分钟？','どのくらいまちますか？','0',NULL,'0',NULL)
,('22','5','饮食','我要无烟区的座位','禁煙席をお願いします','0',NULL,'0',NULL)
,('23','5','饮食','我要吸烟区的座位','喫煙席をお願いします','0',NULL,'0',NULL)
,('24','5','饮食','能给我一杯热水吗','暖かいお水をもらえますか','0',NULL,'0',NULL)
,('25','5','饮食','能给我一杯热茶吗','お茶をもらえますか','0',NULL,'0',NULL)
,('26','5','饮食','有中文的菜单吗？','中国語のメニューはありますか','0',NULL,'0',NULL)
,('27','5','饮食','我想指着门前的菜单样本点菜，请过来。','表の食品サンプルで注文したいので来てください。','0',NULL,'0',NULL)
,('28','5','饮食','我想点和那个人同样的食物','あの人が食べているのと同じのをください。','0',NULL,'0',NULL)
,('29','5','饮食','你们的招牌菜是什么','お勧め料理は何ですか','0',NULL,'0',NULL)
,('30','5','饮食','请给我啤酒','生ビールを下さい','0',NULL,'0',NULL)
,('31','5','饮食','请给我白米饭','白いご飯をもらえますか','0',NULL,'0',NULL)
,('32','5','饮食','餐前或餐后有甜点或饮料之类附送吗','食前や食後にデザートやドリンクが付いていますか','0',NULL,'0',NULL)
,('33','5','饮食','我要杏仁豆腐/冰淇淋','杏仁豆腐/アイスクリームを下さい','0',NULL,'0',NULL)
,('34','5','饮食','我要热咖啡/冰咖啡/乌龙茶/果汁','ホットコーヒー/アイスコーヒー/ウロン茶/ジュースを下さい','0',NULL,'0',NULL)
,('35','5','饮食','可以使用信用卡吗','クレッジカードが使えますか','0',NULL,'0',NULL)
,('36','5','饮食','银联/VISA/MasterCard/JCB中哪些可以用','銀聯/VISA/MasterCard/JCBのうち、どちらが使えますか','0',NULL,'0',NULL)
,('37','5','饮食','对不起，只收现金','現金のみ。申し訳ありません。','0',NULL,'0',NULL)
,('38','5','饮食','请给我发票','領収書を下さい','0',NULL,'0',NULL)
,('39','5','饮食','发票抬头空白即可','領収書の宛に空白のままで構いません','0',NULL,'0',NULL)
,('40','5','饮食','发票抬头请写(请自己写给收银店员)','領収書の宛に　　　をお願いします','0',NULL,'0',NULL)
,('41','5','饮食','我刚才把东西忘记在店里了','忘れ物があります','0',NULL,'0',NULL)
,('42','5','饮食','是包包/钱包/手袋/衣服/雨伞/手提箱','鞄/財布/手袋/服/傘/スーツケース','0',NULL,'0',NULL)
,('43','5','饮食','是黑色/白色/灰色/银色/红色/花纹','色は黒い/白い/灰色/シルバー/赤い/花柄','0',NULL,'0',NULL)
,('44','5','住宿','住一天多少钱？','一泊でいくらですか？','0',NULL,'0',NULL)
,('45','5','住宿','有更便宜的房间吗？','もう少し安い部屋ありますか？','0',NULL,'0',NULL)
,('46','5','住宿','我订一间单人房。','シングル部屋の予約お願いします。','0',NULL,'0',NULL)
,('47','5','住宿','我订一间双人房。','ダブル部屋の予約お願いします。','0',NULL,'0',NULL)
,('48','5','住宿','我要换钱。','両替をしたいですが。','0',NULL,'0',NULL)
,('49','5','住宿','我被锁在门外了。','鍵を部屋の中に忘れました。','0',NULL,'0',NULL)
,('50','5','住宿','门打不开。','ドアが開けることできません。','0',NULL,'0',NULL)
,('51','5','住宿','没有热水','お湯が出ません。','0',NULL,'0',NULL)
,('52','5','住宿','空调坏了','エアコンが壊れました。','0',NULL,'0',NULL)
,('53','5','住宿','请帮我结账退房。','チェックアウトお願いします。','0',NULL,'0',NULL)
,('54','5','站内求助','售票处在哪？','切符売り場を教えてください。','0',NULL,'0',NULL)
,('55','5','站内求助','时刻表在哪呢？','時刻表はどこでしょうか？','0',NULL,'0',NULL)
,('56','5','站内求助','打扰一下，地铁站在哪里呢？','すいません、地下鉄の駅はどこでしょうか。','0',NULL,'0',NULL)
,('57','5','站内求助','在哪里下车好呢？','どこで下りたらいいのでしょうか。','0',NULL,'0',NULL)
,('58','5','站内求助','在哪个站台等车呢？','どのホームで乗ったらいいのでしょうか。','0',NULL,'0',NULL)
,('59','5','站内求助','在哪里换乘呢？','どこで乗り替えるのでしょうか。','0',NULL,'0',NULL)
,('60','5','站内求助','我要去机场。','空港へ行きたいですが。','0',NULL,'0',NULL)
,('61','5','站内求助','我要买一张到XX的票','XXまでの切符を一枚ください。','0',NULL,'0',NULL)
,('62','5','站内求助','我不知道怎么买票。','切符の買い方がわかりません。','0',NULL,'0',NULL)
,('63','5','站内求助','这里是银座线吗？','ここは銀座線の駅ですか？','0',NULL,'0',NULL)
,('64','5','站内求助','这里是丸内线吗？','ここは丸ノ内線の駅ですか？','0',NULL,'0',NULL)
,('65','5','站内求助','这里是日比谷线吗？','ここは日比谷線の駅ですか？','0',NULL,'0',NULL)
,('66','5','站内求助','这里是东西线吗？','ここは東西線の駅ですか？','0',NULL,'0',NULL)
,('67','5','站内求助','这里是千代田线吗？','ここは千代田線の駅ですか？','0',NULL,'0',NULL)
,('68','5','站内求助','这里是有乐町线吗？','ここは有楽町線の駅ですか？','0',NULL,'0',NULL)
,('69','5','站内求助','这里是半藏门线吗？','ここは半蔵門線の駅ですか？','0',NULL,'0',NULL)
,('70','5','站内求助','这里是南北线吗？','ここは南北線の駅ですか？','0',NULL,'0',NULL)
,('71','5','站内求助','这里是副都心线吗？','ここは副都心線の駅ですか？','0',NULL,'0',NULL)
,('72','5','站内求助','我的包忘记在车厢里了。','かばんを電車に置き忘れた。','0',NULL,'0',NULL)
,('73','5','站内求助','我的钱包丢了。','財布がなくなりました。','0',NULL,'0',NULL)
,('74','5','站内求助','我的护照丢了。','パスポートをなくしました。','0',NULL,'0',NULL)
,('75','5','站内求助','我的手机丢了。','携帯電話をなくしました。','0',NULL,'0',NULL)
,('76','5','站内求助','我的东西掉到轨道里面了','ものを線路に落としてしまいました','0',NULL,'0',NULL)
,('77','5','站内求助','大概是这样的尺寸（比划）。','大体これぐらいの大きさです。','0',NULL,'0',NULL)
,('78','5','站内求助','是黑色/白色/银色/红色/茶色/灰色的。','色は黒色/白色/シルーバ/赤色/茶色/灰色です。','0',NULL,'0',NULL)
;

