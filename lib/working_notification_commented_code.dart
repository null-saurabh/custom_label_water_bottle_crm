//const { onDocumentCreated } = require("firebase-functions/v2/firestore");
//const admin = require("firebase-admin");
//
//admin.initializeApp();
//
//const db = admin.firestore();
//const messaging = admin.messaging();
//
///**
// * 🔔 Send notification to ALL active admin devices
///**
// * 🔔 Send notification to ALL active admin devices
// * - WEB: data-only (prevents duplicate notifications)
// * - ANDROID: notification + data (background/killed works)
// */
//async function sendToAllAdmins({ title, body, data }) {
//  const snap = await db
//    .collection("admin_devices")
//    .where("isActive", "==", true)
//    .get();
//
//  if (snap.empty) {
//    console.log("⚠️ No admin devices found");
//    return;
//  }
//
//  // Split tokens by platform
//  const webTokens = [];
//  const androidTokens = [];
//
//  snap.docs.forEach((doc) => {
//    const d = doc.data() || {};
//    const platform = d.platform; // "web" | "android"
//    const token = doc.id;
//
//    if (platform === "web") webTokens.push(token);
//    else if (platform === "android") androidTokens.push(token);
//  });
//
//  // IMPORTANT: FCM data payload values must be strings
//  const dataPayload = {
//    ...Object.fromEntries(
//      Object.entries(data || {}).map(([k, v]) => [k, String(v ?? "")])
//    ),
//    title: String(title ?? ""),
//    body: String(body ?? ""),
//  };
//
//  // 1) WEB: data-only, service worker will show notification
//  if (webTokens.length > 0) {
//    const webMessage = {
//      tokens: webTokens,
//      data: dataPayload,
//      webpush: {
//        fcmOptions: {
//          // Optional: clicking notification opens your app root
//          link: "https://custom-label-bottle-crm.web.app/",
//        },
//      },
//    };
//
//    const webResp = await messaging.sendEachForMulticast(webMessage);
//    console.log(`🌐 WEB sent: ${webResp.successCount}/${webTokens.length}`);
//
//    if (webResp.failureCount > 0) {
//      webResp.responses.forEach((r, i) => {
//        if (!r.success) console.error("❌ WEB failed token:", webTokens[i], r.error);
//      });
//    }
//  }
//
//  // 2) ANDROID: notification + data
//  if (androidTokens.length > 0) {
//    const androidMessage = {
//      tokens: androidTokens,
//      notification: { title, body },
//      data: dataPayload,
//      android: {
//        priority: "high",
//      },
//    };
//
//    const andResp = await messaging.sendEachForMulticast(androidMessage);
//    console.log(`🤖 ANDROID sent: ${andResp.successCount}/${androidTokens.length}`);
//
//    if (andResp.failureCount > 0) {
//      andResp.responses.forEach((r, i) => {
//        if (!r.success) console.error("❌ ANDROID failed token:", androidTokens[i], r.error);
//      });
//    }
//  }
//}
//
//
//function formatShortDate(ts) {
//  if (!ts) return "—";
//  const d = ts.toDate ? ts.toDate() : new Date(ts);
//
//  // Example: "29 Jan"
//  return d.toLocaleDateString("en-IN", {
//    day: "2-digit",
//    month: "short",
//  });
//}
//
//function safeStr(v, fallback = "") {
//  const s = (v ?? "").toString().trim();
//  return s.length ? s : fallback;
//}
//
//
//function compactSpaces(s) {
//  return safeStr(s).replace(/\s+/g, " ");
//}
//
//async function getItemName(itemId) {
//  if (!itemId) return "Item";
//
//  try {
//    const snap = await db.collection("inventory_items").doc(itemId).get();
//    return snap.exists ? snap.data().name || "Item" : "Item";
//  } catch (_) {
//    return "Item";
//  }
//}
//
//async function getSupplierNameByStock(stockId) {
//  if (!stockId) return "Supplier";
//
//  try {
//    const stockSnap = await db
//      .collection("inventory_stocks")
//      .doc(stockId)
//      .get();
//
//    if (!stockSnap.exists) return "Supplier";
//
//    const supplierId = stockSnap.data().supplierId;
//    if (!supplierId) return "Supplier";
//
//    const supplierSnap = await db
//      .collection("suppliers")
//      .doc(supplierId)
//      .get();
//
//    return supplierSnap.exists
//      ? supplierSnap.data().name || "Supplier"
//      : "Supplier";
//  } catch (_) {
//    return "Supplier";
//  }
//}
//
//
//async function getOrderSnapshot(orderId) {
//  if (!orderId) return null;
//  try {
//    const snap = await db.collection("orders").doc(orderId).get();
//    return snap.exists ? snap.data() : null;
//  } catch (_) {
//    return null;
//  }
//}
//
//function inr(v) {
//  return Number(v || 0).toLocaleString("en-IN");
//}
//
//
//
//exports.onLeadCreated = onDocumentCreated("leads/{leadId}", async (event) => {
//  const leadId = event.params.leadId;
//  const lead = event.data?.data?.();
//
//  if (!lead) {
//    console.log("⚠️ onLeadCreated: missing lead data");
//    return;
//  }
//
//  const businessName = compactSpaces(lead.businessName) || "New Lead";
//  const businessType = compactSpaces(lead.businessType);
//  const area = compactSpaces(lead.area) || compactSpaces(lead.city) || "—";
//  const monthly = compactSpaces(lead.expectedMonthlyVolume) || "Not sure";
//
//  const title = businessType
//    ? `🧲 ${businessName} (${businessType})`
//    : `🧲 ${businessName}`;
//
//  const body = `Area: ${area} • Monthly: ${monthly}`;
//
//  await sendToAllAdmins({
//    title,
//    body,
//    data: {
//      type: "lead",
//      id: leadId,
//      businessName: businessName,
//      businessType: businessType,
//      area: area,
//      expectedMonthlyVolume: monthly,
//    },
//  });
//});
//
//
//
//exports.onOrderCreated = onDocumentCreated(
//  "orders/{orderId}",
//  async (event) => {
//    const orderId = event.params.orderId;
//    const order = event.data?.data?.(); // Firestore doc data
//
//    if (!order) {
//      console.log("⚠️ onOrderCreated: missing order data");
//      return;
//    }
//
//    const businessName = safeStr(order.clientNameSnapshot, "New Order");
//    const orderNumber = safeStr(order.orderNumber, ""); // optional
//    const qty = Number(order.orderedQuantity ?? 0);
//    const due = formatShortDate(order.expectedDeliveryDate);
//
//    // ✅ Nice-looking notification text
//    const title = orderNumber
//      ? `🧾 ${businessName} (${orderNumber})`
//      : `🧾 ${businessName}`;
//
//    const body = `Bottles: ${qty.toLocaleString("en-IN")} • Due: ${due}`;
//
//    await sendToAllAdmins({
//      title,
//      body,
//      data: {
//        type: "order",
//        id: orderId,
//        orderNumber: orderNumber,
//        clientName: businessName,
//        orderedQuantity: String(qty),
//        expectedDeliveryDate: String(due),
//      },
//    });
//  }
//);
//
//
///* =========================
//   CLIENTS
//   ========================= */
//exports.onClientCreated = onDocumentCreated("clients/{clientId}", async (event) => {
//  const clientId = event.params.clientId;
//  const c = event.data?.data?.();
//
//  if (!c) {
//    console.log("⚠️ onClientCreated: missing client data");
//    return;
//  }
//
//  const businessName = String(c.businessName ?? "").trim() || "New Client";
//  const businessType = String(c.businessType ?? "").trim();
//
//  const contactName = String(c.contactName ?? "").trim() || "—";
//
//  // locations[0].area is the best "area" field (fallback to city)
//  const loc0 = Array.isArray(c.locations) && c.locations.length > 0 ? c.locations[0] : {};
//  const area = String(loc0?.area ?? "").trim() || String(loc0?.city ?? "").trim() || "—";
//
//  const title = businessType
//    ? `✅ Client Added: ${businessName} (${businessType})`
//    : `✅ Client Added: ${businessName}`;
//
//  const body = `Contact: ${contactName} • Area: ${area}`;
//
//  await sendToAllAdmins({
//    title,
//    body,
//    data: {
//      type: "client",
//      id: clientId,
//      businessName: businessName,
//      businessType: businessType,
//      contactName: contactName,
//      area: area,
//    },
//  });
//});
//
//
//
//exports.onInventoryItemCreated = onDocumentCreated(
//  "inventory_items/{itemId}",
//  async (event) => {
//    const itemId = event.params.itemId;
//    const item = event.data?.data?.();
//
//    if (!item) return;
//
//    const name = String(item.name ?? "").trim() || "New Item";
//    const category = String(item.category ?? "").trim();
//    const reorderLevel = Number(item.reorderLevel ?? 0);
//
//    const prettyCategory =
//      category.length > 0
//        ? category.charAt(0).toUpperCase() + category.slice(1)
//        : "Item";
//
//    const title = `📦 Item Added: ${name}`;
//    const body = `Category: ${prettyCategory} • Reorder @ ${reorderLevel.toLocaleString("en-IN")}`;
//
//    await sendToAllAdmins({
//      title,
//      body,
//      data: {
//        type: "inventory_item",
//        itemId: itemId,
//        category: category,
//      },
//    });
//  }
//);
//
//
//
//exports.onSupplierCreated = onDocumentCreated(
//  "suppliers/{supplierId}",
//  async (event) => {
//    const supplierId = event.params.supplierId;
//    const s = event.data?.data?.();
//
//    if (!s) return;
//
//    const name = String(s.name ?? "").trim() || "New Supplier";
//    const contact = String(s.contactPerson ?? "").trim() || "—";
//    const phone = String(s.phone ?? "").trim() || "—";
//
//    const title = `🏭 Supplier Added: ${name}`;
//    const body = `Name: ${contact} • Phone: ${phone}`;
//
//    await sendToAllAdmins({
//      title,
//      body,
//      data: {
//        type: "supplier",
//        supplierId: supplierId,
//      },
//    });
//  }
//);
//
//
//
//exports.onInventoryStockActivityCreated = onDocumentCreated(
//  "inventory_items/{itemId}/activities/{activityId}",
//  async (event) => {
//    const a = event.data?.data?.();
//    if (!a) return;
//
//    const { itemId } = event.params;
//    const type = a.type;
//    const source = a.source || "";
//
//    // 🚫 Ignore inactive / soft-deleted activities
//    if (a.isActive === false) return;
//
//    /* ============================
//       Helpers (local, safe)
//    ============================ */
//
//    const getItemName = async () => {
//      try {
//        const snap = await db
//          .collection("inventory_items")
//          .doc(itemId)
//          .get();
//
//        return snap.exists
//          ? snap.data()?.name || "Item"
//          : "Item";
//      } catch (_) {
//        return "Item";
//      }
//    };
//
//    const getSupplierNameByStock = async (stockId) => {
//      if (!stockId) return "Supplier";
//
//      try {
//        const stockSnap = await db
//          .collection("inventory_stocks")
//          .doc(stockId)
//          .get();
//
//        if (!stockSnap.exists) return "Supplier";
//
//        const supplierId = stockSnap.data()?.supplierId;
//        if (!supplierId) return "Supplier";
//
//        const supplierSnap = await db
//          .collection("suppliers")
//          .doc(supplierId)
//          .get();
//
//        return supplierSnap.exists
//          ? supplierSnap.data()?.name || "Supplier"
//          : "Supplier";
//      } catch (_) {
//        return "Supplier";
//      }
//    };
//
//    /* ============================
//       1️⃣ STOCK ADDED (PURCHASE)
//    ============================ */
//    if (
//      type === "stock_in" &&
//      source === "purchase" &&
//      a.referenceType === "inventory_stock" &&
//      Number(a.stockDelta) > 0
//    ) {
//      const qty = Number(a.stockDelta);
//      const itemName = await getItemName();
//
//      await sendToAllAdmins({
//        title: "📥 Stock Added",
//        body: `${itemName} • Qty: ${qty.toLocaleString("en-IN")}`,
//        data: {
//          type: "inventory",
//          activityType: "stock_added",
//          itemId,
//          stockId: a.referenceId,
//        },
//      });
//
//      return;
//    }
//
//    /* ============================
//       2️⃣ STOCK RECEIVED
//    ============================ */
//    if (
//      type === "stock_in" &&
//      source === "purchase_receive" &&
//      a.referenceType === "inventory_stock" &&
//      Number(a.stockDelta) > 0
//    ) {
//      const qty = Number(a.stockDelta);
//      const itemName = await getItemName();
//
//      const rateText =
//        a.unitCost != null
//          ? ` • ₹${Number(a.unitCost).toFixed(0)}/unit`
//          : "";
//
//      await sendToAllAdmins({
//        title: "📦 Stock Received",
//        body: `${itemName} • +${qty.toLocaleString("en-IN")} units${rateText}`,
//        data: {
//          type: "inventory",
//          activityType: "stock_received",
//          itemId,
//          stockId: a.referenceId,
//        },
//      });
//
//      return;
//    }
//
//    /* ============================
//       3️⃣ SUPPLIER PAYMENT
//    ============================ */
//    if (
//      type === "supplier_payment" &&
//      source === "inventory_stock" &&
//      a.referenceType === "inventory_stock" &&
//      Number(a.amount) > 0
//    ) {
//      const amount = Number(a.amount);
//      const supplierName = await getSupplierNameByStock(a.referenceId);
//
//      await sendToAllAdmins({
//        title: "💸 Supplier Payment",
//        body: `${supplierName} • ₹${amount.toLocaleString("en-IN")}`,
//        data: {
//          type: "inventory",
//          activityType: "supplier_payment",
//          stockId: a.referenceId,
//        },
//      });
//    }
//  }
//);
//
//
//exports.onClientPaymentCreated = onDocumentCreated(
//  "order_expenses/{expenseId}",
//  async (event) => {
//    const e = event.data?.data?.();
//    if (!e) return;
//
//    if (e.category !== "client_payment" || e.direction !== "in") return;
//    if (Number(e.amount) <= 0) return;
//
//    const order = await getOrderSnapshot(e.orderId);
//    const client = order?.clientNameSnapshot || "Client";
//
//    await sendToAllAdmins({
//      title: "💰 Client Payment Received",
//      body: `${client} • ₹${inr(e.amount)}`,
//      data: {
//        type: "order",
//        activityType: "client_payment",
//        orderId: e.orderId,
//      },
//    });
//  }
//);
//
//
//exports.onOrderExpenseCreated = onDocumentCreated(
//  "order_expenses/{expenseId}",
//  async (event) => {
//    const e = event.data?.data?.();
//    if (!e) return;
//
//    if (e.direction !== "out") return;
//    if (Number(e.amount) <= 0) return;
//
//    const title = "💸 Expense Added";
//    const body = `${e.category || "Expense"} • ₹${inr(e.amount)}`;
//
//    await sendToAllAdmins({
//      title,
//      body,
//      data: {
//        type: "order",
//        activityType: "expense",
//        orderId: e.orderId,
//      },
//    });
//  }
//);
//
//
//exports.onOrderDeliveryCreated = onDocumentCreated(
//  "order_delivery_entries/{deliveryId}",
//  async (event) => {
//    const d = event.data?.data?.();
//    if (!d) return;
//
//    if (Number(d.quantityDeliveredToday) <= 0) return;
//
//    const order = await getOrderSnapshot(d.orderId);
//    const orderNo = order?.orderNumber || "Order";
//
//    await sendToAllAdmins({
//      title: "🚚 Order Delivered",
//      body: `${orderNo} • ${inr(d.quantityDeliveredToday)} bottles`,
//      data: {
//        type: "order",
//        activityType: "delivery",
//        orderId: d.orderId,
//      },
//    });
//  }
//);
//
//
//
//exports.onOrderProductionCreated = onDocumentCreated(
//  "order_production_entries/{prodId}",
//  async (event) => {
//    const p = event.data?.data?.();
//    if (!p) return;
//
//    if (Number(p.quantityProducedToday) <= 0) return;
//
//    const order = await getOrderSnapshot(p.orderId);
//    const orderNo = order?.orderNumber || "Order";
//
//    await sendToAllAdmins({
//      title: "🏭 Production Updated",
//      body: `${orderNo} • +${inr(p.quantityProducedToday)} bottles`,
//      data: {
//        type: "order",
//        activityType: "production",
//        orderId: p.orderId,
//      },
//    });
//  }
//);
//
//
//
//
//
//
//
