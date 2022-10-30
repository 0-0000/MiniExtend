function writeLeftColumn(t){
	document.write('<div class="doc-col-md2">\
	<div class="left-column">\
		<div class="tab" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;">\
			<span>miniExtend 参考手册</span>\
		</div>\
		<div class="sidebar-box gallery-list">\
		<div class="design" id="leftcolumn">\
			<a target="_top" title="miniExtend 参考手册" href="doc.html">\
				miniExtend 参考手册\
			</a>\
			<a target="_top" title="miniExtend 安装" href="environment.html">\
				miniExtend 安装\
			</a>\
			<a target="_top" title="miniExtend 注意事项" href="appointment.html">\
				miniExtend 注意事项\
			</a>\
			<a target="_top" title="miniExtend Core" href="core.html">\
				miniExtend Core\
			</a>\
			<a target="_top" title="miniExtend Time" href="time.html">\
				miniExtend Time\
			</a>\
			<a target="_top" title="miniExtend Console" href="console.html">\
				miniExtend Console\
			</a>\
			<a target="_top" title="miniExtend Object" href="object.html">\
				miniExtend Object\
			</a>\
			<a target="_top" title="miniExtend Event" href="event.html">\
				miniExtend Event\
			</a>\
			<a target="_top" title="miniExtend CustomUI" href="ui.html">\
				miniExtend CustomUI\
			</a>\
		</div>\
		</div>\
	</div>\
	</div>')
	let children = document.getElementById("leftcolumn").children
	for(let i = 0; i < children.length; ++i){
		if(children[i].title == t){
			children[i].style.backgroundColor = "rgb(150, 185, 125)"
			children[i].style.fontWeight = "bold"
			children[i].style.color = "rgb(255, 255, 255)"
			let fa_fa_tag = document.createElement("i")
			fa_fa_tag.className = "fa fa-tag"
			fa_fa_tag.setAttribute("aria-hidden", "true")
			children[i].insertBefore(fa_fa_tag, children[i].firstChild)
			break
		}
	}
}

function writePreviousNextLinks(state, href1, title1, href2, title2){
	if(state == ""){
		document.write('<div class="previous-next-links">\
			<div class="previous-design-link" style="display:none"></div>\
			<div class="next-design-link" style="display:none"></div>\
		</div>')
	}else if(state == "prevnext"){
		document.write('<div class="previous-next-links">\
			<div class="previous-design-link">\
				<a href="" id="tmpid1">\
					<i style="font-size:16px;" class="fa fa-arrow-left" aria-hidden="true"></i>\
				</a>\
				<a href="" rel="next" title="" id="tmpid2"></a>\
			</div>\
			<div class="next-design-link">\
				<a href="" rel="next" title="" id="tmpid3"></a>\
				<a href="" id="tmpid4">\
					<i style="font-size:16px;" class="fa fa-arrow-right" aria-hidden="true"></i>\
				</a>\
			</div>\
		</div>')
		let tmpNode1 = document.getElementById("tmpid1")
		let tmpNode2 = document.getElementById("tmpid2")
		let tmpNode3 = document.getElementById("tmpid3")
		let tmpNode4 = document.getElementById("tmpid4")
		tmpNode1.setAttribute("href", href1)
		tmpNode1.id = ""
		tmpNode2.setAttribute("href", href1)
		tmpNode2.setAttribute("titie", title1)
		tmpNode2.innerHTML = title1
		tmpNode2.id = ""
		tmpNode3.setAttribute("href", href2)
		tmpNode3.setAttribute("titie", title2)
		tmpNode3.innerHTML = title2
		tmpNode3.id = ""
		tmpNode4.setAttribute("href", href2)
		tmpNode4.id = ""
	}else if(state == "prev"){
		document.write('<div class="previous-next-links">\
			<div class="previous-design-link">\
				<a href="" id="tmpid1">\
					<i style="font-size:16px;" class="fa fa-arrow-left" aria-hidden="true"></i>\
				</a>\
				<a href="" rel="next" title="" id="tmpid2"></a>\
			</div>\
			<div class="next-design-link" style="display:none"></div>\
		</div>')
		let tmpNode1 = document.getElementById("tmpid1")
		let tmpNode2 = document.getElementById("tmpid2")
		tmpNode1.setAttribute("href", href1)
		tmpNode1.id = ""
		tmpNode2.setAttribute("href", href1)
		tmpNode2.setAttribute("titie", title1)
		tmpNode2.innerHTML = title1
		tmpNode2.id = ""
	}else if(state == "next"){
		document.write('<div class="previous-next-links">\
			<div class="previous-design-link" style="display:none"></div>\
			<div class="next-design-link">\
				<a href="" rel="next" title="" id="tmpid1"></a>\
				<a href="" id="tmpid2">\
					<i style="font-size:16px;" class="fa fa-arrow-right" aria-hidden="true"></i>\
				</a>\
			</div>\
		</div>')
		let tmpNode1 = document.getElementById("tmpid1")
		let tmpNode2 = document.getElementById("tmpid2")
		tmpNode1.setAttribute("href", href1)
		tmpNode1.setAttribute("titie", title1)
		tmpNode1.innerHTML = title1
		tmpNode1.id = ""
		tmpNode2.setAttribute("href", href1)
		tmpNode2.id = ""
	}
}
