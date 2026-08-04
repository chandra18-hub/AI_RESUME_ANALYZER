const skills=["html","css","javascript","react","java","python","sql","git","github","node","tailwind"];
async function analyzeFile(){
 const f=document.getElementById('file').files[0];
 if(!f){alert("Please choose a file.");return;}
 let text="";
 document.getElementById("status").textContent="Reading resume...";
 if(f.name.endsWith(".txt")) text=await f.text();
 else if(f.name.endsWith(".docx")){
  const buf=await f.arrayBuffer(); text=(await mammoth.extractRawText({arrayBuffer:buf})).value;
 }else if(f.name.endsWith(".pdf")){
  const pdf=await pdfjsLib.getDocument({data:await f.arrayBuffer()}).promise;
  for(let i=1;i<=pdf.numPages;i++){const p=await pdf.getPage(i);const c=await p.getTextContent();text+=c.items.map(x=>x.str).join(" ");}
 }else{return alert("Unsupported file.");}
 show(text.toLowerCase());
}
function show(t){
 let score=0;
 const sec=["education","experience","project","skills","certification"];
 sec.forEach(s=>{if(t.includes(s))score+=15;});
 if(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i.test(t))score+=10;
 if(/\d{10}/.test(t))score+=10;
 const found=skills.filter(s=>t.includes(s)); score=Math.min(100,score+found.length*3);
 let html=`<h2>ATS Score: ${score}/100</h2><h3>Detected Skills</h3>`;
 found.forEach(s=>html+=`<span class="skill">${s}</span>`);
 html+=`<h3 style="margin-top:20px">Suggestions</h3><ul>`;
 if(!t.includes("github")) html+="<li>Add GitHub profile</li>";
 if(!t.includes("linkedin")) html+="<li>Add LinkedIn profile</li>";
 if(!t.includes("experience")) html+="<li>Add experience or internships</li>";
 if(!t.includes("certification")) html+="<li>Add certifications</li>";
 html+="</ul>";
 document.getElementById("status").textContent="Analysis Complete";
 document.getElementById("result").innerHTML=html;
}