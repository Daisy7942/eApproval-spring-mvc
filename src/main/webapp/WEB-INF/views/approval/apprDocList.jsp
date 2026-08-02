<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>eApproval - 결재 대기 문서</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Malgun Gothic", "Segoe UI", sans-serif; }
  body { display: flex; background: #f0f2f7; min-height: 100vh; }

  /* ===== 사이드바 (dashboard와 동일 — 추후 include로 공통화) ===== */
  .sidebar { width: 230px; background: #1c2a47; color: #cdd6e6; display: flex; flex-direction: column; position: fixed; top: 0; bottom: 0; }
  .logo { display: flex; align-items: center; gap: 10px; padding: 18px 20px; }
  .logo .mark { width: 34px; height: 34px; background: #2f6bff; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: bold; }
  .logo b { color: #fff; font-size: 15px; display: block; }
  .logo span { font-size: 11px; color: #8fa0bd; }
  .btn-new { margin: 6px 16px 14px; padding: 11px; background: #2f6bff; color: #fff; border: none; border-radius: 8px; font-size: 14px; cursor: pointer; width: calc(100% - 32px); }
  .profile { display: flex; align-items: center; gap: 10px; background: #24345a; margin: 0 12px 16px; padding: 10px 12px; border-radius: 10px; }
  .avatar { width: 34px; height: 34px; border-radius: 50%; background: #2f6bff; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 14px; }
  .profile b { color: #fff; font-size: 13px; display: block; }
  .profile span { font-size: 11px; color: #8fa0bd; }
  .menu { flex: 1; overflow-y: auto; }
  .menu .section { font-size: 11px; color: #7487a8; padding: 12px 20px 4px; }
  .menu a { display: flex; align-items: center; justify-content: space-between; padding: 9px 20px; color: #cdd6e6; text-decoration: none; font-size: 13px; }
  .menu a:hover { background: #24345a; color: #fff; }
  .menu a.active { background: #2c3e66; color: #fff; border-radius: 8px; margin: 0 8px; padding: 9px 12px; }
  .menu a .badge { background: #e5484d; color: #fff; font-size: 10px; border-radius: 9px; padding: 2px 7px; }
  .sidebar-bottom { border-top: 1px solid #2c3a5c; padding: 10px 0; }
  .sidebar-bottom a { display: block; padding: 8px 20px; color: #9fb0ca; font-size: 13px; text-decoration: none; }

  /* ===== 메인 ===== */
  .main { flex: 1; margin-left: 230px; }
  .topbar { background: #fff; border-bottom: 1px solid #e3e7ef; padding: 12px 28px; display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #666; }
  .topbar .crumb b { color: #222; }
  .content { padding: 24px 28px; max-width: 1400px; }

  .list-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
  .list-head h2 { font-size: 20px; color: #1c2a47; }   /* 공용화 시: 문서함 이름으로 교체 */
  .list-head .count { font-size: 13px; color: #888; }

  .toolbar { display: flex; gap: 10px; margin-bottom: 14px; }
  .toolbar .search { flex: 1; position: relative; }
  .toolbar input { width: 100%; padding: 10px 12px 10px 34px; border: 1px solid #dbe1ea; border-radius: 8px; font-size: 13px; background: #fff; }
  .toolbar .search::before { content: "🔍"; position: absolute; left: 11px; top: 9px; font-size: 12px; }
  .tabs { display: flex; gap: 6px; }
  .tab { padding: 9px 14px; border-radius: 8px; font-size: 13px; color: #555; background: #fff; border: 1px solid #dbe1ea; cursor: pointer; text-decoration: none; }
  .tab.active { background: #2f6bff; border-color: #2f6bff; color: #fff; }

  /* ===== 표 ===== */
  .table-wrap { background: #fff; border: 1px solid #e3e7ef; border-radius: 10px; overflow: hidden; }
  table { width: 100%; border-collapse: collapse; }
  thead th { text-align: left; font-size: 12px; color: #8a93a3; font-weight: normal; padding: 12px 16px; border-bottom: 1px solid #e9edf3; background: #fafbfd; }
  tbody td { padding: 14px 16px; border-bottom: 1px solid #f2f4f8; font-size: 13px; vertical-align: middle; }
  tbody tr:last-child td { border-bottom: none; }
  tbody tr:hover { background: #f7f9fd; cursor: pointer; }
  td.doc-no { font-family: Consolas, monospace; font-size: 12px; color: #98a3b5; }
  td.title b { color: #222; font-size: 13.5px; }
  td.title .urgent { color: #e5484d; margin-right: 4px; }
  .drafter b { display: block; color: #333; }
  .drafter span