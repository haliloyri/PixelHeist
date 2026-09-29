extends Node
## Purchase and ad provider boundary (design r13 sections 13-14). The game talks only to
## this node. Until real SDKs are approved (P16-24), the fake providers below answer:
## they never charge money or show real ads. A real provider must emit the same signals
## with the platform's own transaction id / verified reward event id.
signal purchase_finished(product_id: String, status: String, transaction_id: String)
signal restore_finished(product_ids: Array)
signal rewarded_finished(placement: String, status: String, event_id: String)
signal interstitial_finished()

## "success", "cancelled", "failed" or "pending" — tests set this; players always get success.
var fake_purchase_status := "success"
## "rewarded", "skipped", "unavailable".
var fake_ad_status := "rewarded"
## Fake store memory of permanent products, to exercise Restore Purchases.
var fake_owned: Dictionary = {}
var provider_name := "fake"
var ads_available := true
var _serial := 0

func _next_id(prefix: String) -> String:
	_serial += 1
	return "%s:%s:%d:%d" % [provider_name, prefix, int(Time.get_unix_time_from_system()), _serial]

func purchase(product_id: String) -> void:
	var status := fake_purchase_status
	var id := _next_id("txn") if status == "success" else ""
	if status == "success": fake_owned[product_id] = true
	purchase_finished.emit.call_deferred(product_id, status, id)

func restore() -> void:
	restore_finished.emit.call_deferred(fake_owned.keys())

func show_rewarded(placement: String) -> void:
	var status := fake_ad_status if ads_available else "unavailable"
	var id := _next_id("ad") if status == "rewarded" else ""
	rewarded_finished.emit.call_deferred(placement, status, id)

func show_interstitial() -> void:
	interstitial_finished.emit.call_deferred()
