$(document).ready(function(){
if (document.domain=="ocg.xpg.jp")
{
	if ((document.URL.indexOf("/rank/")>=0)||(document.URL.indexOf("/deck/")>=0))
	{
		var b = $("<input type='button' class='s' value='翻译中文'></input>")
		var y = $("<input type='button' class='s' value='生成卡组' id='mdeck' disabled=true></input>")
		b.click(function(){
			$(this).parent().next().find("a").parent().each(function(){
				var a = $(this).children("a")
				var h = a.attr("href")
				if (h.indexOf("/c/")==0)
				{
					try{
						var c = cards[parseInt(h.slice(3,-1))]
						a.text(c.name)
						a.attr("id",c.number)
						a.attr("name",c.name)
					}catch(err){
						alert(err.message)
					}
					$("#mdeck").attr("disabled",false)
				}
			})
			$(this).attr("value","翻译完毕")
			$(this).attr("disabled",true)
		})
		y.click(function(){
			$(this).parent().next().after($("<p><div id='deck' style='background:#FFFFFF;float:right;width:100%'></div></p>"))
			var t = $(this).parent().next().find("tr").first()
			var m = "<div style='background:#FBFBFB;float:left;border:1px blue solid;width:45%'><p>YGOPRO卡组：<br />请把数字和字母复制到txt，另存为.ydk<br />#created by ...<br />#main<br />"	
			var m2 = "<div style='background:#FBFBFB;float:right;border:1px blue solid;width:45%'><p>主卡组：<br />怪兽:<br />"
			//var isside = "false"
			//var num = 0
			while (t.size()>0)
			{
				var a = t.find("a")
				if (a.size()>0)
				{
					for (var i=0;i<parseInt(t.children().first().text());i++)
					{
						m+=a.attr("id")+"<br />"
					}
					if(i>1)
					{
						m2+=i+" ["+a.attr("name")+"]<br />"
						//num = i
					}
					else
					{
						m2+="1 ["+a.attr("name")+"]<br />"
						//num = 1
					}
				}
				else if (t.children(".l").text().indexOf("魔法")==0)
				{
					m2+=" 魔法：<br />"
				}
				else if (t.children(".l").text().indexOf("罠")==0)
				{
					m2+=" 陷阱：<br />"
				}
				else if (t.children(".l").text().indexOf("エク")==0)
				{
					m+="#extra<br />"
					m2+="额外卡组：<br />"
				}
				else if (t.children(".l").text().indexOf("サ")==0)
				{
					m+="!side<br />"
					m2+="副卡组：<br />"
					//isside = "true"
				}
				//var m3 = {id:+a.attr("id"),connt:num,side:isside}
				t = t.next()
			}
			m+="</p></div>"
			m2+="</p></div>"
			$("#deck").append(m+m2)
			$(this).attr("value","生成完毕")
		})
		$("table.jHover.f9").prev().append(b)
		$("table.jHover.f9.c2").prev().append(y)
	}
}
})