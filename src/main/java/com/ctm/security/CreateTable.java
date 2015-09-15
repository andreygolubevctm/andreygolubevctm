package com.ctm.security;

import java.io.*;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by voba on 31/08/2015.
 */
public class CreateTable {
    private static String NOT_USED_FIELDS = "evar1\n" +
            "evar2\n" +
            "evar3\n" +
            "evar4\n" +
            "evar5\n" +
            "evar6\n" +
            "evar7\n" +
            "evar8\n" +
            "evar9\n" +
            "evar10\n" +
            "evar11\n" +
            "evar12\n" +
            "evar13\n" +
            "evar14\n" +
            "evar15\n" +
            "evar16\n" +
            "evar17\n" +
            "evar18\n" +
            "evar19\n" +
            "evar20\n" +
            "evar21\n" +
            "evar22\n" +
            "evar23\n" +
            "evar24\n" +
            "evar25\n" +
            "evar26\n" +
            "evar27\n" +
            "evar28\n" +
            "evar29\n" +
            "evar30\n" +
            "evar31\n" +
            "evar32\n" +
            "evar33\n" +
            "evar34\n" +
            "evar35\n" +
            "evar36\n" +
            "evar37\n" +
            "evar38\n" +
            "evar39\n" +
            "evar40\n" +
            "evar41\n" +
            "evar42\n" +
            "evar43\n" +
            "evar44\n" +
            "evar45\n" +
            "evar46\n" +
            "evar47\n" +
            "evar48\n" +
            "evar49\n" +
            "evar50\n" +
            "evar51\n" +
            "evar52\n" +
            "evar53\n" +
            "evar54\n" +
            "evar55\n" +
            "evar56\n" +
            "evar57\n" +
            "evar58\n" +
            "evar59\n" +
            "evar60\n" +
            "evar61\n" +
            "evar62\n" +
            "evar63\n" +
            "evar64\n" +
            "evar65\n" +
            "evar66\n" +
            "evar67\n" +
            "evar68\n" +
            "evar69\n" +
            "evar70\n" +
            "evar99\n" +
            "evar100\n" +
            "post_evar1\n" +
            "post_evar2\n" +
            "post_evar3\n" +
            "post_evar4\n" +
            "post_evar5\n" +
            "post_evar6\n" +
            "post_evar7\n" +
            "post_evar8\n" +
            "post_evar9\n" +
            "post_evar10\n" +
            "post_evar11\n" +
            "post_evar12\n" +
            "post_evar13\n" +
            "post_evar14\n" +
            "post_evar15\n" +
            "post_evar16\n" +
            "post_evar17\n" +
            "post_evar18\n" +
            "post_evar19\n" +
            "post_evar20\n" +
            "post_evar21\n" +
            "post_evar22\n" +
            "post_evar23\n" +
            "post_evar24\n" +
            "post_evar25\n" +
            "post_evar26\n" +
            "post_evar27\n" +
            "post_evar28\n" +
            "post_evar29\n" +
            "post_evar30\n" +
            "post_evar31\n" +
            "post_evar32\n" +
            "post_evar33\n" +
            "post_evar34\n" +
            "post_evar35\n" +
            "post_evar36\n" +
            "post_evar37\n" +
            "post_evar38\n" +
            "post_evar39\n" +
            "post_evar40\n" +
            "post_evar41\n" +
            "post_evar42\n" +
            "post_evar43\n" +
            "post_evar44\n" +
            "post_evar45\n" +
            "post_evar46\n" +
            "post_evar47\n" +
            "post_evar48\n" +
            "post_evar49\n" +
            "post_evar50\n" +
            "post_evar51\n" +
            "post_evar52\n" +
            "post_evar53\n" +
            "post_evar54\n" +
            "post_evar55\n" +
            "post_evar56\n" +
            "post_evar57\n" +
            "post_evar58\n" +
            "post_evar59\n" +
            "post_evar60\n" +
            "post_evar61\n" +
            "post_evar62\n" +
            "post_evar63\n" +
            "post_evar64\n" +
            "post_evar65\n" +
            "post_evar66\n" +
            "post_evar67\n" +
            "post_evar68\n" +
            "post_evar69\n" +
            "post_evar70\n" +
            "post_evar99\n" +
            "post_evar100\n" +
            "prop1\n" +
            "prop2\n" +
            "prop3\n" +
            "prop4\n" +
            "prop5\n" +
            "prop6\n" +
            "prop7\n" +
            "prop8\n" +
            "prop9\n" +
            "prop10\n" +
            "prop11\n" +
            "prop12\n" +
            "prop13\n" +
            "prop14\n" +
            "prop15\n" +
            "prop16\n" +
            "prop17\n" +
            "prop18\n" +
            "prop19\n" +
            "prop20\n" +
            "prop21\n" +
            "prop22\n" +
            "prop23\n" +
            "prop24\n" +
            "prop25\n" +
            "prop26\n" +
            "prop27\n" +
            "prop28\n" +
            "prop29\n" +
            "prop30\n" +
            "prop31\n" +
            "prop32\n" +
            "prop33\n" +
            "prop34\n" +
            "prop35\n" +
            "prop36\n" +
            "prop37\n" +
            "prop38\n" +
            "prop39\n" +
            "prop40\n" +
            "prop41\n" +
            "prop42\n" +
            "prop43\n" +
            "prop44\n" +
            "prop45\n" +
            "prop46\n" +
            "prop47\n" +
            "prop48\n" +
            "prop49\n" +
            "prop50\n" +
            "prop51\n" +
            "prop52\n" +
            "prop53\n" +
            "prop54\n" +
            "prop55\n" +
            "prop56\n" +
            "prop57\n" +
            "prop58\n" +
            "prop59\n" +
            "prop60\n" +
            "prop61\n" +
            "prop62\n" +
            "prop63\n" +
            "prop64\n" +
            "prop65\n" +
            "prop66\n" +
            "prop67\n" +
            "prop68\n" +
            "prop69\n" +
            "prop70\n" +
            "post_prop1\n" +
            "post_prop2\n" +
            "post_prop3\n" +
            "post_prop4\n" +
            "post_prop5\n" +
            "post_prop6\n" +
            "post_prop7\n" +
            "post_prop8\n" +
            "post_prop9\n" +
            "post_prop10\n" +
            "post_prop11\n" +
            "post_prop12\n" +
            "post_prop13\n" +
            "post_prop14\n" +
            "post_prop15\n" +
            "post_prop16\n" +
            "post_prop17\n" +
            "post_prop18\n" +
            "post_prop19\n" +
            "post_prop20\n" +
            "post_prop21\n" +
            "post_prop22\n" +
            "post_prop23\n" +
            "post_prop24\n" +
            "post_prop25\n" +
            "post_prop26\n" +
            "post_prop27\n" +
            "post_prop28\n" +
            "post_prop29\n" +
            "post_prop30\n" +
            "post_prop31\n" +
            "post_prop32\n" +
            "post_prop33\n" +
            "post_prop34\n" +
            "post_prop35\n" +
            "post_prop36\n" +
            "post_prop37\n" +
            "post_prop38\n" +
            "post_prop39\n" +
            "post_prop40\n" +
            "post_prop41\n" +
            "post_prop42\n" +
            "post_prop43\n" +
            "post_prop44\n" +
            "post_prop45\n" +
            "post_prop46\n" +
            "post_prop47\n" +
            "post_prop48\n" +
            "post_prop49\n" +
            "post_prop50\n" +
            "post_prop51\n" +
            "post_prop52\n" +
            "post_prop53\n" +
            "post_prop54\n" +
            "post_prop55\n" +
            "post_prop56\n" +
            "post_prop57\n" +
            "post_prop58\n" +
            "post_prop59\n" +
            "post_prop60\n" +
            "post_prop61\n" +
            "post_prop62\n" +
            "post_prop63\n" +
            "post_prop64\n" +
            "post_prop65\n" +
            "post_prop66\n" +
            "post_prop67\n" +
            "post_prop68\n" +
            "post_prop69\n" +
            "post_prop70";
    public static void main(String[] args) throws Exception {
        //splitTSV();
        //insertHeader();
        createTable();
    }

    private static void splitTSV() throws Exception {
        File dir = new File("C:\\Users\\voba\\Downloads\\bla");
        for(File file : dir.listFiles()) {
            int i = 0;
            int newFile = 0;
            if(file.isFile()) {
                BufferedReader br = new BufferedReader(new FileReader(file));
                String line;

                FileOutputStream outputStream1 = new FileOutputStream("C:\\Users\\voba\\Downloads\\bla/split/" + file.getName() + newFile++);
                FileOutputStream outputStream2 = new FileOutputStream("C:\\Users\\voba\\Downloads\\bla/split/" + file.getName() + newFile++);
                FileOutputStream outputStream3 = new FileOutputStream("C:\\Users\\voba\\Downloads\\bla/split/" + file.getName() + newFile++);
                while((line = br.readLine()) != null) {
                    String split[] = line.split("\t");
                    for(String data : split) {
                        i++;
                        if(i <= 255) {
                            if(i == 255) {
                                outputStream1.write((data + "\n").getBytes());
                            } else {
                                outputStream1.write((data + "\t").getBytes());
                            }
                        } else if(i > 255 && i <= 510) {
                            if(i == 510) {
                                outputStream2.write((data + "\n").getBytes());
                            } else {
                                outputStream2.write((data + "\t").getBytes());
                            }
                        } else {
                            if(i == 652 || (i == 651 && split.length == 651)) {
                                outputStream3.write((data + "\n").getBytes());
                                i = 0;
                            } else {
                                outputStream3.write((data + "\t").getBytes());
                            }
                        }
                    }
                }
            }
        }
    }

    /*private static void insertHeader() throws Exception {
        File dir = new File("C:\\Users\\voba\\Downloads\\bla");

        String header = "accept_language\tbrowser\tbrowser_height\tbrowser_width\tc_color\tcampaign\tcarrier\tchannel\tclick_action\tclick_action_type\tclick_context\tclick_context_type\tclick_sourceid\tclick_tag\tcode_ver\tcolor\tconnection_type\tcookies\tcountry\tct_connect_type\tcurr_factor\tcurr_rate\tcurrency\tcust_hit_time_gmt\tcust_visid\tdaily_visitor\tdate_time\tdomain\tduplicate_events\tduplicate_purchase\tduplicated_from\tef_id\tevar1\tevar2\tevar3\tevar4\tevar5\tevar6\tevar7\tevar8\tevar9\tevar10\tevar11\tevar12\tevar13\tevar14\tevar15\tevar16\tevar17\tevar18\tevar19\tevar20\tevar21\tevar22\tevar23\tevar24\tevar25\tevar26\tevar27\tevar28\tevar29\tevar30\tevar31\tevar32\tevar33\tevar34\tevar35\tevar36\tevar37\tevar38\tevar39\tevar40\tevar41\tevar42\tevar43\tevar44\tevar45\tevar46\tevar47\tevar48\tevar49\tevar50\tevar51\tevar52\tevar53\tevar54\tevar55\tevar56\tevar57\tevar58\tevar59\tevar60\tevar61\tevar62\tevar63\tevar64\tevar65\tevar66\tevar67\tevar68\tevar69\tevar70\tevar71\tevar72\tevar73\tevar74\tevar75\tevar76\tevar77\tevar78\tevar79\tevar80\tevar81\tevar82\tevar83\tevar84\tevar85\tevar86\tevar87\tevar88\tevar89\tevar90\tevar91\tevar92\tevar93\tevar94\tevar95\tevar96\tevar97\tevar98\tevar99\tevar100\tevent_list\texclude_hit\tfirst_hit_page_url\tfirst_hit_pagename\tfirst_hit_referrer\tfirst_hit_time_gmt\tgeo_city\tgeo_country\tgeo_dma\tgeo_region\tgeo_zip\thier1\thier2\thier3\thier4\thier5\thit_source\thit_time_gmt\thitid_high\thitid_low\thomepage\thourly_visitor\tip\tip2\tj_jscript\tjava_enabled\tjavascript\tlanguage\tlast_hit_time_gmt\tlast_purchase_num\tlast_purchase_time_gmt\tmcvisid\tmobile_id\tmobileaction\tmobileappid\tmobilecampaigncontent\tmobilecampaignmedium\tmobilecampaignname\tmobilecampaignsource\tmobilecampaignterm\tmobiledayofweek\tmobiledayssincefirstuse\tmobiledayssincelastuse\tmobiledevice\tmobilehourofday\tmobileinstalldate\tmobilelaunchnumber\tmobileltv\tmobilemessageid\tmobilemessageonline\tmobileosversion\tmobileresolution\tmonthly_visitor\tmvvar1\tmvvar2\tmvvar3\tnamespace\tnew_visit\tos\tp_plugins\tpage_event\tpage_event_var1\tpage_event_var2\tpage_event_var3\tpage_type\tpage_url\tpagename\tpaid_search\tpartner_plugins\tpersistent_cookie\tplugins\tpointofinterest\tpointofinterestdistance\tpost_browser_height\tpost_browser_width\tpost_campaign\tpost_channel\tpost_cookies\tpost_currency\tpost_cust_hit_time_gmt\tpost_cust_visid\tpost_ef_id\tpost_evar1\tpost_evar2\tpost_evar3\tpost_evar4\tpost_evar5\tpost_evar6\tpost_evar7\tpost_evar8\tpost_evar9\tpost_evar10\tpost_evar11\tpost_evar12\tpost_evar13\tpost_evar14\tpost_evar15\tpost_evar16\tpost_evar17\tpost_evar18\tpost_evar19\tpost_evar20\tpost_evar21\tpost_evar22\tpost_evar23\tpost_evar24\tpost_evar25\tpost_evar26\tpost_evar27\tpost_evar28\tpost_evar29\tpost_evar30\tpost_evar31\tpost_evar32\tpost_evar33\tpost_evar34\tpost_evar35\tpost_evar36\tpost_evar37\tpost_evar38\tpost_evar39\tpost_evar40\tpost_evar41\tpost_evar42\tpost_evar43\tpost_evar44\tpost_evar45\tpost_evar46\tpost_evar47\tpost_evar48\tpost_evar49\tpost_evar50\tpost_evar51\tpost_evar52\tpost_evar53\tpost_evar54\tpost_evar55\tpost_evar56\tpost_evar57\tpost_evar58\tpost_evar59\tpost_evar60\tpost_evar61\tpost_evar62\tpost_evar63\tpost_evar64\tpost_evar65\tpost_evar66\tpost_evar67\tpost_evar68\tpost_evar69\tpost_evar70\tpost_evar71\tpost_evar72\tpost_evar73\tpost_evar74\tpost_evar75\tpost_evar76\tpost_evar77\tpost_evar78\tpost_evar79\tpost_evar80\tpost_evar81\tpost_evar82\tpost_evar83\tpost_evar84\tpost_evar85\tpost_evar86\tpost_evar87\tpost_evar88\tpost_evar89\tpost_evar90\tpost_evar91\tpost_evar92\tpost_evar93\tpost_evar94\tpost_evar95\tpost_evar96\tpost_evar97\tpost_evar98\tpost_evar99\tpost_evar100\tpost_event_list\tpost_hier1\tpost_hier2\tpost_hier3\tpost_hier4\tpost_hier5\tpost_java_enabled\tpost_keywords\tpost_mobileaction\tpost_mobileappid\tpost_mobilecampaigncontent\tpost_mobilecampaignmedium\tpost_mobilecampaignname\tpost_mobilecampaignsource\tpost_mobilecampaignterm\tpost_mobiledayofweek\tpost_mobiledayssincefirstuse\tpost_mobiledayssincelastuse\tpost_mobiledevice\tpost_mobilehourofday\tpost_mobileinstalldate\tpost_mobilelaunchnumber\tpost_mobileltv\tpost_mobilemessageid\tpost_mobilemessageonline\tpost_mobileosversion\tpost_mobileresolution\tpost_mvvar1\tpost_mvvar2\tpost_mvvar3\tpost_page_event\tpost_page_event_var1\tpost_page_event_var2\tpost_page_event_var3\tpost_page_type\tpost_page_url\tpost_pagename\tpost_pagename_no_url\tpost_partner_plugins\tpost_persistent_cookie\tpost_pointofinterest\tpost_pointofinterestdistance\tpost_product_list\tpost_prop1\tpost_prop2\tpost_prop3\tpost_prop4\tpost_prop5\tpost_prop6\tpost_prop7\tpost_prop8\tpost_prop9\tpost_prop10\tpost_prop11\tpost_prop12\tpost_prop13\tpost_prop14\tpost_prop15\tpost_prop16\tpost_prop17\tpost_prop18\tpost_prop19\tpost_prop20\tpost_prop21\tpost_prop22\tpost_prop23\tpost_prop24\tpost_prop25\tpost_prop26\tpost_prop27\tpost_prop28\tpost_prop29\tpost_prop30\tpost_prop31\tpost_prop32\tpost_prop33\tpost_prop34\tpost_prop35\tpost_prop36\tpost_prop37\tpost_prop38\tpost_prop39\tpost_prop40\tpost_prop41\tpost_prop42\tpost_prop43\tpost_prop44\tpost_prop45\tpost_prop46\tpost_prop47\tpost_prop48\tpost_prop49\tpost_prop50\tpost_prop51\tpost_prop52\tpost_prop53\tpost_prop54\tpost_prop55\tpost_prop56\tpost_prop57\tpost_prop58\tpost_prop59\tpost_prop60\tpost_prop61\tpost_prop62\tpost_prop63\tpost_prop64\tpost_prop65\tpost_prop66\tpost_prop67\tpost_prop68\tpost_prop69\tpost_prop70\tpost_prop71\tpost_prop72\tpost_prop73\tpost_prop74\tpost_prop75\tpost_purchaseid\tpost_referrer\tpost_s_kwcid\tpost_search_engine\tpost_socialaccountandappids\tpost_socialassettrackingcode\tpost_socialauthor\tpost_socialcontentprovider\tpost_socialfbstories\tpost_socialfbstorytellers\tpost_socialinteractioncount\tpost_socialinteractiontype\tpost_sociallanguage\tpost_sociallatlong\tpost_sociallikeadds\tpost_socialmentions\tpost_socialowneddefinitioninsighttype\tpost_socialowneddefinitioninsightvalue\tpost_socialowneddefinitionmetric\tpost_socialowneddefinitionpropertyvspost\tpost_socialownedpostids\tpost_socialownedpropertyid\tpost_socialownedpropertyname\tpost_socialownedpropertypropertyvsapp\tpost_socialpageviews\tpost_socialpostviews\tpost_socialpubcomments\tpost_socialpubposts\tpost_socialpubrecommends\tpost_socialpubsubscribers\tpost_socialterm\tpost_socialtotalsentiment\tpost_state\tpost_survey\tpost_t_time_info\tpost_tnt\tpost_tnt_action\tpost_transactionid\tpost_video\tpost_videoad\tpost_videoadinpod\tpost_videoadplayername\tpost_videoadpod\tpost_videochannel\tpost_videocontenttype\tpost_videopath\tpost_videoplayername\tpost_videosegment\tpost_visid_high\tpost_visid_low\tpost_visid_type\tpost_zip\tprev_page\tproduct_list\tproduct_merchandising\tprop1\tprop2\tprop3\tprop4\tprop5\tprop6\tprop7\tprop8\tprop9\tprop10\tprop11\tprop12\tprop13\tprop14\tprop15\tprop16\tprop17\tprop18\tprop19\tprop20\tprop21\tprop22\tprop23\tprop24\tprop25\tprop26\tprop27\tprop28\tprop29\tprop30\tprop31\tprop32\tprop33\tprop34\tprop35\tprop36\tprop37\tprop38\tprop39\tprop40\tprop41\tprop42\tprop43\tprop44\tprop45\tprop46\tprop47\tprop48\tprop49\tprop50\tprop51\tprop52\tprop53\tprop54\tprop55\tprop56\tprop57\tprop58\tprop59\tprop60\tprop61\tprop62\tprop63\tprop64\tprop65\tprop66\tprop67\tprop68\tprop69\tprop70\tprop71\tprop72\tprop73\tprop74\tprop75\tpurchaseid\tquarterly_visitor\tref_domain\tref_type\treferrer\tresolution\ts_kwcid\ts_resolution\tsampled_hit\tsearch_engine\tsearch_page_num\tsecondary_hit\tservice\tsocialaccountandappids\tsocialassettrackingcode\tsocialauthor\tsocialcontentprovider\tsocialfbstories\tsocialfbstorytellers\tsocialinteractioncount\tsocialinteractiontype\tsociallanguage\tsociallatlong\tsociallikeadds\tsocialmentions\tsocialowneddefinitioninsighttype\tsocialowneddefinitioninsightvalue\tsocialowneddefinitionmetric\tsocialowneddefinitionpropertyvspost\tsocialownedpostids\tsocialownedpropertyid\tsocialownedpropertyname\tsocialownedpropertypropertyvsapp\tsocialpageviews\tsocialpostviews\tsocialpubcomments\tsocialpubposts\tsocialpubrecommends\tsocialpubsubscribers\tsocialterm\tsocialtotalsentiment\tsourceid\tstate\tstats_server\tt_time_info\ttnt\ttnt_action\ttnt_post_vista\ttransactionid\ttruncated_hit\tua_color\tua_os\tua_pixels\tuser_agent\tuser_hash\tuser_server\tuserid\tusername\tva_closer_detail\tva_closer_id\tva_finder_detail\tva_finder_id\tva_instance_event\tva_new_engagement\tvideo\tvideoad\tvideoadinpod\tvideoadplayername\tvideoadpod\tvideochannel\tvideocontenttype\tvideopath\tvideoplayername\tvideosegment\tvisid_high\tvisid_low\tvisid_new\tvisid_timestamp\tvisid_type\tvisit_keywords\tvisit_num\tvisit_page_num\tvisit_referrer\tvisit_search_engine\tvisit_start_page_url\tvisit_start_pagename\tvisit_start_time_gmt\tweekly_visitor\tyearly_visitor\tzip\n";
        for(File file : dir.listFiles()) {
            if(file.getName().endsWith("tsv")) {
                int offset = 0;
                RandomAccessFile r = new RandomAccessFile(new File(file.getAbsolutePath()), "rw");
                RandomAccessFile rtemp = new RandomAccessFile(new File(file.getAbsolutePath() + "~"), "rw");
                long fileSize = r.length();
                FileChannel sourceChannel = r.getChannel();
                FileChannel targetChannel = rtemp.getChannel();
                sourceChannel.transferTo(offset, (fileSize - offset), targetChannel);
                sourceChannel.truncate(offset);
                r.seek(offset);
                r.write(header.getBytes());
                long newOffset = r.getFilePointer();
                targetChannel.position(0L);
                sourceChannel.transferFrom(targetChannel, newOffset, (fileSize - offset));
                sourceChannel.close();
                targetChannel.close();
            }
        }
    }*/

    private static void createTable() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("C:/Users/voba/Downloads/bla/01-ctm-prd_2015-08-01.tsv2"));

        System.out.println(br.ready());

        String line = br.readLine();
        System.out.println(line);

        String split[] = line.split("\t");
        String createTable = "CREATE TABLE omniture.omniture_feeds2(\n";
        createTable += "`Id` int(11) unsigned NOT NULL AUTO_INCREMENT, \n";

        int i = 0;
        for(String column : split) {
            if((split[i].startsWith("evar") || split[i].startsWith("post_evar") || split[i].startsWith("prop") || split[i].startsWith("post_prop"))) {
                if(NOT_USED_FIELDS.indexOf(split[i]) != -1) {
                    createTable += "`" + split[i++] + "` VARCHAR(255), \n";
                } else {
                    createTable += "`" + split[i++] + "` VARCHAR(1), \n";
                }
            } else {
                createTable += "`" + split[i++] + "` VARCHAR(255), \n";
            }
        }

        createTable += "PRIMARY KEY (`Id`)\n";
        createTable += ");";

        System.out.println(createTable);

        br.close();
    }
}
