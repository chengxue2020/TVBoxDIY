#!/bin/bash

#获取目录
CURRENT_DIR=$(cd $(dirname $0); pwd)
num=$(find $CURRENT_DIR -name gradlew  | awk -F"/" '{print NF-1}')
DIR=$(find $CURRENT_DIR -name gradlew  | cut -d \/ -f$num)
cd $CURRENT_DIR/$DIR
#共存
sed -i 's/com.github.tvbox.osc/com.github.tvbox.Frank/g' $CURRENT_DIR/$DIR/app/build.gradle
#改版本号
sed -i '2i def static buildTime\(\) \{\n    return new Date\(\)\.format\(\"yyyyMMdd-HHmm\", TimeZone.getTimeZone\("GMT+08:00"\)\)\n    \}\n' $CURRENT_DIR/$DIR/app/build.gradle
#sed -i 's#'1.1.0'#更改后的日期'  $CURRENT_DIR/$DIR/app/build.gradle

#签名
signingConfigs='ICAgIHNpZ25pbmdDb25maWdzIHtcCiAgICAgICAgaWYgKHByb2plY3QuaGFzUHJvcGVydHkoIlJFTEVBU0VfU1RPUkVfRklMRSIpKSB7XAogICAgICAgICAgICBteUNvbmZpZyB7XAogICAgICAgICAgICAgICAgc3RvcmVGaWxlIGZpbGUoUkVMRUFTRV9TVE9SRV9GSUxFKVwKICAgICAgICAgICAgICAgIHN0b3JlUGFzc3dvcmQgUkVMRUFTRV9TVE9SRV9QQVNTV09SRFwKICAgICAgICAgICAgICAgIGtleUFsaWFzIFJFTEVBU0VfS0VZX0FMSUFTXAogICAgICAgICAgICAgICAga2V5UGFzc3dvcmQgUkVMRUFTRV9LRVlfUEFTU1dPUkRcCiAgICAgICAgICAgICAgICB2MVNpZ25pbmdFbmFibGVkIHRydWVcCiAgICAgICAgICAgICAgICB2MlNpZ25pbmdFbmFibGVkIHRydWVcCiAgICAgICAgICAgICAgICBlbmFibGVWM1NpZ25pbmcgPSB0cnVlXAogICAgICAgICAgICAgICAgZW5hYmxlVjRTaWduaW5nID0gdHJ1ZVwKICAgICAgICAgICAgfVwKICAgICAgICB9XAogICAgfVwKXA=='
signingConfig='ICAgICAgICAgICAgaWYgKHByb2plY3QuaGFzUHJvcGVydHkoIlJFTEVBU0VfU1RPUkVfRklMRSIpKSB7XAogICAgICAgICAgICAgICAgc2lnbmluZ0NvbmZpZyBzaWduaW5nQ29uZmlncy5teUNvbmZpZ1wKICAgICAgICAgICAgfVwK'
signingConfigs="$(echo "$signingConfigs" |base64 -d )"
signingConfig="$(echo "$signingConfig" |base64 -d )"
sed -i -e "/defaultConfig {/i\\$signingConfigs " -e "/debug {/a\\$signingConfig " -e "/release {/a\\$signingConfig " $CURRENT_DIR/$DIR/app/build.gradle
cp -f $CURRENT_DIR/DIY/TVBoxOSC.jks $CURRENT_DIR/$DIR/app/TVBoxOSC.jks
cp -f $CURRENT_DIR/DIY/TVBoxOSC.jks $CURRENT_DIR/$DIR/TVBoxOSC.jks
echo "" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_STORE_FILE=./TVBoxOSC.jks" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_KEY_ALIAS=TVBoxOSC" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_STORE_PASSWORD=TVBoxOSC" >>$CURRENT_DIR/$DIR/gradle.properties
echo "RELEASE_KEY_PASSWORD=TVBoxOSC" >>$CURRENT_DIR/$DIR/gradle.properties
#xwalk修复
#sed -i 's/download.01.org\/crosswalk\/releases\/crosswalk\/android\/maven2/raw.githubusercontent.com\/chengxue2020\/TVBoxDIY\/main/g' $CURRENT_DIR/$DIR/build.gradle
#更改默认项
mv $CURRENT_DIR/DIY/App.java $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
#名称修改
sed -i 's/TVBox/TVBox_3.0/g' $CURRENT_DIR/$DIR/app/src/main/res/values/strings.xml

#背景修改
mv $CURRENT_DIR/DIY/app_bg.png $CURRENT_DIR/$DIR/app/src/main/res/drawable/app_bg.png
#logo修改
mv $CURRENT_DIR/DIY/hdpi-app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-hdpi/app_icon.png
mv $CURRENT_DIR/DIY/xhdpi-app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xhdpi/app_icon.png
mv $CURRENT_DIR/DIY/xxhdpi-app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xxhdpi/app_icon.png
mv $CURRENT_DIR/DIY/xxxhdpi-app_icon.png $CURRENT_DIR/$DIR/app/src/main/res/drawable-xxxhdpi/app_icon.png
mv $CURRENT_DIR/DIY/app_banner.png $CURRENT_DIR/$DIR/app/src/main/res/drawable/app_banner.png
#载入动画修改
mv $CURRENT_DIR/DIY/icon_loading.png $CURRENT_DIR/$DIR/app/src/main/res/drawable/icon_loading.png
mv $CURRENT_DIR/DIY/anim_loading.xml $CURRENT_DIR/$DIR/app/src/main/res/drawable/anim_loading.xml
#添加颜色值---------------------------------
sed -i '7i \<color name=\"color_FF18D6FF\"\>\#FF18D6FF\<\/color\>' $CURRENT_DIR/$DIR/app/src/main/res/values/colors.xml
sed -i '8i \<color name=\"color_8800FF0A\"\>\#8800FF0A\<\/color\>' $CURRENT_DIR/$DIR/app/src/main/res/values/colors.xml

#接口内置
sed -i 's/API_URL, \"\"/API_URL, \"https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/chengxue2020\/Cat-ports\/main\/main.json\"/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
#EPG接口
sed -i 's/EPG_URL,\"\"/EPG_URL,\"https:\/\/epg.112114.xyz\/\"/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/LivePlayActivity.java

#点播详情界面"第几集“字体的颜色
sed -i 's/getColor\(R.color.color_02F8E1\)/getColor\(R.color.color_1890FF\)/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/SeriesAdapter.java
#点播界面集数背景
sed -i 's/color_6C3D3D3D/color_66000000/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_source_series_focus.xml
#首页直播图标修改
mv $CURRENT_DIR/DIY/icon_live.xml $CURRENT_DIR/$DIR/app/src/main/res/drawable/icon_live.xml
#首页年月日+周几
sed -i 's/yyyy\/MM\/dd HH:mm/yyyy\/MM\/dd EE HH:mm/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/HomeActivity.java
#点播界面底部菜单背景
sed -i 's/drawable\/shape_dialog_filter_bg/drawable\/shape_dialog_vod_filter_bg/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml
mv $CURRENT_DIR/DIY/shape_dialog_vod_filter_bg.xml $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_dialog_vod_filter_bg.xml

#点播界面中间的网速下移
sed -i 's/dimen\/vs_40/dimen\/vs_76/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/player_vod_control_view.xml

#直播界面频道列表中跳动条颜色-------------------------------------------------
sed -i 's/setColor\(Color\.RED\)/setColor\(Color\.WHITE\)/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/tv/widget/AudioWaveView.java
#直播界面右上角图标由软件图标更改为载入图标
sed -i 's/app_icon/icon_loading/g' $CURRENT_DIR/$DIR/app/src/main/res/layout/activity_live_play.xml
#点播界面进度条背景色
sed -i 's/color_6C3D3D3D/color_353744/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_dialog_filter_bg.xml
#点播界面进度条预缓存颜色
sed -i 's/color_CC353744/color_8800FF0A/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_dialog_filter_bg.xml
#点播界面进度条已播放部分颜色
sed -i 's/color_353744/color_FF18D6FF/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_dialog_filter_bg.xml
#其他
sed -i 's/color_99FFFFFF/color_99000000/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_dialog_filter_bg.xml
sed -i 's/\@color\/color_6C3D3D3D/\#CC181E28/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_user_focus.xml
sed -i 's/radius=\"10mm\"/radius=\"30px\"/g' $CURRENT_DIR/$DIR/app/src/main/res/drawable/shape_user_focus.xml

#增加DOH节点
mv $CURRENT_DIR/DIY/OkGoHelper.java $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/util/OkGoHelper.java

#缩略图清晰度修改
sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/activity/DetailActivity.java
sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/GridAdapter.java
sed -i 's/mContext, 400/mContext, 500/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
sed -i 's/mContext, 300/mContext, 400/g' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/ui/adapter/HistoryAdapter.java
#添加PY支持
wget --no-check-certificate -qO- "https://raw.githubusercontent.com/UndCover/PyramidStore/main/aar/pyramid.aar" -O $CURRENT_DIR/$DIR/app/libs/pyramid.aar
sed -i "/thunder.jar/a\    implementation files('libs@pyramid.aar')" $CURRENT_DIR/$DIR/app/build.gradle
sed -i 's#@#\\#g' $CURRENT_DIR/$DIR/app/build.gradle
sed -i 's#pyramid#\\pyramid#g' $CURRENT_DIR/$DIR/app/build.gradle
echo "" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "#添加PY支持" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-keep public class com.undcover.freedom.pyramid.** { *; }" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-dontwarn com.undcover.freedom.pyramid.**" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-keep public class com.chaquo.python.** { *; }" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
echo "-dontwarn com.chaquo.python.**" >>$CURRENT_DIR/$DIR/app/proguard-rules.pro
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.undcover.freedom.pyramid.PythonLoader;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import com.orhanobut.hawk.Hawk;/a\import com.github.catvod.crawler.SpiderNull;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/PlayerHelper.init/a\        PythonLoader.getInstance().setApplication(this);' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/base/App.java
sed -i '/import android.util.Base64;/a\import com.github.catvod.crawler.SpiderNull;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/import android.util.Base64;/a\import com.undcover.freedom.pyramid.PythonLoader;' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/private void parseJson(String apiUrl, String jsonStr)/a\        PythonLoader.getInstance().setConfig(jsonStr);' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Spider getCSP(SourceBean sourceBean)/a\        if (sourceBean.getApi().startsWith(\"py_\")) {\n        try {\n            return PythonLoader.getInstance().getSpider(sourceBean.getKey(), sourceBean.getExt());\n        } catch (Exception e) {\n            e.printStackTrace();\n            return new SpiderNull();\n        }\n    }' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java
sed -i '/public Object\[\] proxyLoca/a\    try {\n        if(param.containsKey(\"api\")){\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"ck\"))\n                return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n            SourceBean sourceBean = ApiConfig.get().getSource(doStr);\n            return PythonLoader.getInstance().proxyLocal(sourceBean.getKey(),sourceBean.getExt(),param);\n        }else{\n            String doStr = param.get(\"do\").toString();\n            if(doStr.equals(\"live\")) return PythonLoader.getInstance().proxyLocal(\"\",\"\",param);\n        }\n    } catch (Exception e) {\n        e.printStackTrace();\n    }\n' $CURRENT_DIR/$DIR/app/src/main/java/com/github/tvbox/osc/api/ApiConfig.java

echo 'DIY end'
