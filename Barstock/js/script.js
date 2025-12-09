// main.js — BARSTOCK (sin BD): Auth, Admin, Mesero, Cliente, Export, Charts, PDF

// ---------- Storage keys ----------
const LS_INV = "barstock_inv_v3";
const LS_USERS = "barstock_users_v3";
const LS_ORDERS = "barstock_orders_v3";
const LS_SESSION = "barstock_session_v3";

// ---------- Initial data (first load) ----------
let inventory = JSON.parse(localStorage.getItem(LS_INV)) || [
  { id: idGen(), name: "Whisky Premium", category: "Licores", qty: 12, price: 120000, expiry: "" },
  { id: idGen(), name: "Cerveza Artesanal", category: "Cervezas", qty: 30, price: 9000, expiry: "" },
  { id: idGen(), name: "Vodka Royal", category: "Licores", qty: 8, price: 45000, expiry: "" },
  { id: idGen(), name: "Picada Familiar", category: "Snacks", qty: 6, price: 25000, expiry: "" }
];

let users = JSON.parse(localStorage.getItem(LS_USERS)) || [
  { username: "admin", password: "1234", role: "admin" },
  { username: "mesero", password: "1234", role: "mesero" },
  { username: "cliente", password: "0000", role: "cliente" }
];

let orders = JSON.parse(localStorage.getItem(LS_ORDERS)) || [];
let session = JSON.parse(localStorage.getItem(LS_SESSION)) || null;
let cart = [];

// Save initial seed if first time
localStorage.setItem(LS_INV, JSON.stringify(inventory));
localStorage.setItem(LS_USERS, JSON.stringify(users));
localStorage.setItem(LS_ORDERS, JSON.stringify(orders));

// ---------- DOM refs ----------
const welcomeText = document.getElementById("welcomeText");
const btnOpenLogin = document.getElementById("btnOpenLogin");
const btnOpenRegister = document.getElementById("btnOpenRegister");
const btnLogout = document.getElementById("btnLogout");

const modalLogin = document.getElementById("modalLogin");
const modalRegister = document.getElementById("modalRegister");
const doLoginBtn = document.getElementById("doLogin");
const doRegisterBtn = document.getElementById("doRegister");

const adminPanel = document.getElementById("adminPanel");
const meseroPanel = document.getElementById("meseroPanel");
const clientePanel = document.getElementById("clientePanel");

const adminTbody = document.getElementById("adminTbody");
const chartCategoriesEl = document.getElementById("chartCategories");
const chartTopEl = document.getElementById("chartTop");

const meseroGrid = document.getElementById("meseroGrid");
const ordersList = document.getElementById("ordersList");

const clienteGrid = document.getElementById("clienteGrid");
const cartItems = document.getElementById("cartItems");
const cartTotal = document.getElementById("cartTotal");

// bind header buttons
btnOpenLogin.addEventListener("click", () => modalOpen("modalLogin"));
btnOpenRegister.addEventListener("click", () => modalOpen("modalRegister"));
btnLogout.addEventListener("click", logout);
doLoginBtn && doLoginBtn.addEventListener("click", doLogin);
doRegisterBtn && doRegisterBtn.addEventListener("click", doRegister);

// helpers
function idGen(){ return Date.now().toString(36) + Math.random().toString(36).slice(2,6); }
function saveAll(){
  localStorage.setItem(LS_INV, JSON.stringify(inventory));
  localStorage.setItem(LS_USERS, JSON.stringify(users));
  localStorage.setItem(LS_ORDERS, JSON.stringify(orders));
  localStorage.setItem(LS_SESSION, JSON.stringify(session));
}
function money(n){ return `COP ${Number(n).toLocaleString("es-CO")}`; }
function modalOpen(id){ document.getElementById(id).classList.remove("hidden"); }
function closeModal(id){ document.getElementById(id).classList.add("hidden"); }
function showWelcome(){ welcomeText.textContent = session ? `${session.username} (${session.role})` : "No autenticado"; }

// ---------- AUTH ----------
function doLogin(){
  const user = document.getElementById("loginUser").value.trim();
  const pass = document.getElementById("loginPass").value;
  const found = users.find(u => u.username === user && u.password === pass);
  if(!found){ alert("Credenciales inválidas"); return; }
  session = { username: found.username, role: found.role, since: new Date().toISOString() };
  saveAll();
  closeModal("modalLogin");
  renderForRole();
}
function doRegister(){
  const user = document.getElementById("regUser").value.trim();
  const pass = document.getElementById("regPass").value;
  const role = document.getElementById("regRole").value;
  if(!user || !pass) { alert("Complete usuario y contraseña"); return; }
  if(users.some(u => u.username === user)){ alert("Usuario ya existe"); return; }
  users.push({ username: user, password: pass, role });
  saveAll();
  closeModal("modalRegister");
  alert("Cuenta creada. Inicia sesión.");
}
function logout(){
  session = null;
  localStorage.removeItem(LS_SESSION);
  saveAll();
  hideAllPanels();
  showWelcome();
}

// ---------- UI: render based on role ----------
function hideAllPanels(){
  adminPanel.classList.add("hidden");
  meseroPanel.classList.add("hidden");
  clientePanel.classList.add("hidden");
  document.getElementById("welcomePanel").classList.add("hidden");
}
function renderForRole(){
  hideAllPanels();
  showWelcome();
  if(!session){ document.getElementById("welcomePanel").classList.remove("hidden"); return; }
  if(session.role === "admin") { adminPanel.classList.remove("hidden"); renderAdminTable(); renderCharts(); }
  if(session.role === "mesero") { meseroPanel.classList.remove("hidden"); renderMeseroGrid(); renderOrders(); }
  if(session.role === "cliente") { clientePanel.classList.remove("hidden"); renderClienteGrid(); renderCart(); }
}

// ---------- ADMIN functions ----------
function renderAdminTable(){
  const q = document.getElementById("searchAdmin").value?.toLowerCase() || "";
  adminTbody.innerHTML = "";
  let totalValue = 0;
  inventory.filter(i => i.name.toLowerCase().includes(q) || i.category.toLowerCase().includes(q))
    .forEach(item => {
      const row = document.createElement("tr");
      const val = (item.qty * (item.price || 0));
      totalValue += val;
      row.innerHTML = `
        <td>${item.name}</td>
        <td>${item.category}</td>
        <td>${item.qty}</td>
        <td>${money(item.price)}</td>
        <td>${item.expiry || "-"}</td>
        <td>
          <button class="btn small" onclick="openEdit('${item.id}')">Editar</button>
          <button class="btn small danger" onclick="deleteItem('${item.id}')">Eliminar</button>
        </td>`;
      adminTbody.appendChild(row);
    });
  document.getElementById("statTotalItems").textContent = inventory.length;
  document.getElementById("statTotalValue").textContent = money(totalValue);
}

function adminAdd(){
  const name = document.getElementById("addName").value.trim();
  const category = document.getElementById("addCategory").value.trim() || "Bebidas";
  const qty = Number(document.getElementById("addQty").value) || 0;
  const price = Number(document.getElementById("addPrice").value) || 0;
  const expiry = document.getElementById("addExpiry").value || "";
  if(!name) return alert("Nombre requerido");
  // if exists same name + category, increase qty
  const found = inventory.find(i => i.name.toLowerCase()===name.toLowerCase() && i.category===category);
  if(found){
    found.qty += qty;
    found.price = price || found.price;
    found.expiry = expiry || found.expiry;
  } else {
    inventory.push({ id: idGen(), name, category, qty, price, expiry });
  }
  saveAll();
  renderAdminTable();
  renderCharts();
  document.getElementById("formAdd")?.reset();
}

function idGen(){ return Date.now().toString(36) + Math.random().toString(36).slice(2,6); }

function deleteItem(id){
  if(!confirm("Eliminar producto?")) return;
  inventory = inventory.filter(i => i.id !== id);
  saveAll(); renderAdminTable(); renderCharts();
}

// Edit modal (simple prompt flow)
function openEdit(id){
  const item = inventory.find(i => i.id === id);
  if(!item) return;
  const name = prompt("Nombre", item.name);
  if(name === null) return;
  const category = prompt("Categoría", item.category);
  if(category === null) return;
  const qty = prompt("Cantidad", item.qty);
  if(qty === null) return;
  const price = prompt("Precio", item.price);
  if(price === null) return;
  const expiry = prompt("Vencimiento (YYYY-MM-DD) o vacío", item.expiry || "");
  item.name = name;
  item.category = category;
  item.qty = Number(qty);
  item.price = Number(price);
  item.expiry = expiry;
  saveAll(); renderAdminTable(); renderCharts();
}

// ---------- CHARTS (Chart.js) ----------
let chartCategories = null;
let chartTop = null;
function renderCharts(){
  // categories distribution by qty
  const catMap = {};
  inventory.forEach(i => catMap[i.category] = (catMap[i.category]||0) + i.qty);
  const labels = Object.keys(catMap);
  const data = labels.map(l => catMap[l]);

  // top 6 products by qty
  const top = [...inventory].sort((a,b)=>b.qty - a.qty).slice(0,6);
  const topLabels = top.map(t => t.name);
  const topValues = top.map(t => t.qty);

  if(chartCategories) chartCategories.destroy();
  if(chartTop) chartTop.destroy();

  chartCategories = new Chart(chartCategoriesEl.getContext('2d'), {
    type: 'doughnut',
    data: { labels, datasets: [{ data, backgroundColor: generateColors(labels.length) }] },
    options: { responsive:true }
  });

  chartTop = new Chart(chartTopEl.getContext('2d'), {
    type: 'bar',
    data: { labels: topLabels, datasets: [{ label: 'Cantidad', data: topValues, backgroundColor: generateColors(topValues.length) }] },
    options: { indexAxis:'y', responsive:true }
  });
}
function generateColors(n){
  const palette = ["#ff00ff","#ff7aff","#ffa3ff","#ff66cc","#99ccff","#66ffb3","#ffcc66","#cc99ff"];
  return Array.from({length:n}, (_,i)=>palette[i % palette.length]);
}

// ---------- MESERO ----------
function renderMeseroGrid(){
  meseroGrid.innerHTML = "";
  inventory.forEach((p,i) => {
    const div = document.createElement("div");
    div.className = "item";
    div.innerHTML = `<h4>${p.name}</h4><p>${p.category} • ${p.qty} u.</p><p>${money(p.price)}</p>
      <button class="btn small" onclick="meseroCreateOrder('${p.id}')">Registrar pedido</button>`;
    meseroGrid.appendChild(div);
  });
}
function meseroCreateOrder(productId){
  const prod = inventory.find(i => i.id === productId);
  if(!prod) return alert("Producto no existe");
  if(prod.qty <= 0) return alert("Sin stock");
  prod.qty -= 1;
  const order = { id: idGen(), productId, name: prod.name, qty:1, price: prod.price, created: new Date().toISOString(), status: "PENDIENTE" };
  orders.unshift(order);
  saveAll();
  renderMeseroGrid();
  renderOrders();
}
function renderOrders(){
  ordersList.innerHTML = "";
  orders.forEach(o => {
    const li = document.createElement("li");
    li.textContent = `${o.created} — ${o.name} ×${o.qty} — ${o.status}`;
    if(o.status === "PENDIENTE"){
      const btn = document.createElement("button");
      btn.className = "btn small";
      btn.textContent = "Marcar lista";
      btn.onclick = () => { o.status = "LISTO"; saveAll(); renderOrders(); renderMeseroGrid(); };
      li.appendChild(btn);
    }
    const del = document.createElement("button");
    del.className = "btn small danger";
    del.style.marginLeft = "8px";
    del.textContent = "Eliminar";
    del.onclick = () => { orders = orders.filter(x=>x.id!==o.id); saveAll(); renderOrders(); };
    li.appendChild(del);
    ordersList.appendChild(li);
  });
}

// print pending orders to PDF (jsPDF + autoTable)
async function printPending(){
  const pending = orders.filter(o=>o.status==="PENDIENTE");
  if(pending.length === 0) return alert("No hay pedidos pendientes");
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();
  doc.setFontSize(14);
  doc.text("Pedidos pendientes — BARSTOCK", 14, 20);
  const rows = pending.map(o => [o.id, o.created, o.name, o.qty, money(o.price)]);
  doc.autoTable({ head:[["ID","Fecha","Producto","Cant","Precio"]], body: rows, startY: 30 });
  doc.save(`BARSTOCK_pedidos_pendientes_${new Date().toISOString().slice(0,10)}.pdf`);
}

// ---------- CLIENTE ----------
function renderClienteGrid(){
  clienteGrid.innerHTML = "";
  inventory.forEach((p,i) => {
    const div = document.createElement("div");
    div.className = "item";
    div.innerHTML = `<h4>${p.name}</h4><p>${p.category} • ${p.qty} u.</p><p>${money(p.price)}</p>
      <button class="btn small" onclick="clienteAddToCart('${p.id}')">Añadir al carrito</button>`;
    clienteGrid.appendChild(div);
  });
}
function clienteAddToCart(id){
  const prod = inventory.find(i=>i.id===id);
  if(!prod || prod.qty <= 0) return alert("Sin stock");
  const existing = cart.find(c=>c.id===id);
  if(existing) existing.qty += 1;
  else cart.push({ id: id, name: prod.name, price: prod.price, qty:1 });
  renderCart();
}
function renderCart(){
  cartItems.innerHTML = "";
  let total = 0;
  cart.forEach(c => {
    const li = document.createElement("li");
    li.textContent = `${c.name} x${c.qty} — ${money(c.qty*c.price)}`;
    const inc = document.createElement("button"); inc.className="btn small"; inc.textContent="+";
    inc.onclick = ()=>{ c.qty++; renderCart(); };
    const dec = document.createElement("button"); dec.className="btn small"; dec.textContent="-";
    dec.onclick = ()=>{ c.qty = Math.max(0, c.qty-1); if(c.qty===0) cart = cart.filter(x=>x.id!==c.id); renderCart(); };
    const rem = document.createElement("button"); rem.className="btn small danger"; rem.textContent="Eliminar";
    rem.onclick = ()=>{ cart = cart.filter(x=>x.id!==c.id); renderCart(); };
    li.appendChild(document.createTextNode(" "));
    li.appendChild(inc); li.appendChild(dec); li.appendChild(rem);
    cartItems.appendChild(li);
    total += c.qty * c.price;
  });
  cartTotal.textContent = money(total);
}
function confirmCart(){
  if(cart.length === 0) return alert("Carrito vacío");
  // check stock
  for(const it of cart){
    const prod = inventory.find(p=>p.id===it.id);
    if(!prod || prod.qty < it.qty) return alert(`Stock insuficiente: ${it.name}`);
  }
  // deduct stock and create orders
  for(const it of cart){
    const prod = inventory.find(p=>p.id===it.id);
    prod.qty -= it.qty;
    const order = { id: idGen(), productId: it.id, name: it.name, qty: it.qty, price: it.price, created: new Date().toISOString(), status: "PENDIENTE" };
    orders.unshift(order);
  }
  cart = []; saveAll(); renderCart(); renderClienteGrid(); renderOrders();
  alert("Pedido confirmado ✔");
}

// ---------- EXPORT / REPORT ----------
function exportExcel(){
  const ws_data = [["Nombre","Categoría","Cantidad","Precio","Vencimiento"]];
  inventory.forEach(i => ws_data.push([i.name,i.category,i.qty,i.price,i.expiry||""]));
  const wb = XLSX.utils.book_new();
  const ws = XLSX.utils.aoa_to_sheet(ws_data);
  XLSX.utils.book_append_sheet(wb, ws, "Inventario");
  XLSX.writeFile(wb, `BARSTOCK_inventario_${new Date().toISOString().slice(0,10)}.xlsx`);
}
function exportCSV(){
  const rows = [["Nombre","Categoría","Cantidad","Precio","Vencimiento"]];
  inventory.forEach(i => rows.push([i.name,i.category,i.qty,i.price,i.expiry||""]));
  const csv = rows.map(r => r.map(v => `"${String(v).replace(/"/g,'""')}"`).join(",")).join("\n");
  const a = document.createElement("a"); a.href = URL.createObjectURL(new Blob([csv], {type:"text/csv"}));
  a.download = `BARSTOCK_inventario_${new Date().toISOString().slice(0,10)}.csv`; a.click();
}
function exportPDF(){
  const { jsPDF } = window.jspdf;
  const doc = new jsPDF();
  doc.text("BARSTOCK — Inventario", 14, 20);
  const rows = inventory.map(i => [i.name, i.category, String(i.qty), String(i.price), i.expiry||"-"]);
  doc.autoTable({ head:[["Nombre","Categoría","Cantidad","Precio","Vencimiento"]], body: rows, startY: 30 });
  doc.save(`BARSTOCK_inventario_${new Date().toISOString().slice(0,10)}.pdf`);
}

// ---------- init ----------
function init(){
  // load possible saved session
  session = JSON.parse(localStorage.getItem(LS_SESSION)) || null;
  if(session) { renderForRole(); showWelcome(); }
  else { showWelcome(); document.getElementById("welcomePanel")?.classList.remove("hidden"); }
  // wire search admin input
  document.getElementById("searchAdmin")?.addEventListener("input", renderAdminTable);
}
function showWelcome(){ document.getElementById("welcomeText").textContent = session ? `${session.username} (${session.role})` : "No autenticado"; }

init();
