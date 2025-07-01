# Changelog

All notable changes to the MCP Proxy TUI project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-07-01

### Added
- **Nix packaging support**: Added Nix flake configuration for reproducible builds across different platforms
- **GitHub Pages deployment**: Automated deployment workflow for project landing page
- **Project landing page**: Created index.html with project overview and documentation

### Changed
- **Project rename**: Renamed from `mcp-probe` to `mcp-trace` for better clarity
- **UI improvements**: 
  - Fixed tab visibility issues in the monitor interface
  - Added context-aware help text that updates based on focused area
  - Improved visual clarity of navigation modes and focus indicators
- **Documentation updates**: Enhanced CLAUDE.md with clearer project guidelines

### Fixed
- **CI/CD**: Fixed GitHub Pages workflow to properly handle artifact uploads
- **Nix CI**: Resolved formatting and clippy issues in Nix build process

## [0.1.0] - 2025-06-17

### Added

#### Core Proxy Features
- **MCP Proxy Server**: STDIO-based proxy that intercepts and forwards JSON-RPC communication between MCP clients and servers
- **Auto-generated proxy names**: Proxy names automatically generated as `mcp-proxy-{random-chars}` when not specified
- **Log buffering with reconnection**: Proxy buffers logs in memory (up to 10,000 messages) and automatically reconnects to monitor with exponential backoff (1-30s)
- **Comprehensive IPC communication**: Unix domain socket-based communication between proxy and monitor

#### Monitor TUI Features
- **Real-time monitoring**: Terminal User Interface for monitoring multiple MCP proxies simultaneously
- **Tabbed log filtering**: Filter logs by type (All, Messages, Errors, System) with message counts
- **Dual-mode navigation system**: 
  - FOLLOW mode: Automatically tracks latest logs (green indicator)
  - NAVIGATE mode: Manual navigation through log history (yellow indicator)
- **Proxy selection and filtering**: Focus-based navigation between proxy list and logs with ability to filter by individual proxy
- **Enhanced log detail view**: 
  - JSON pretty-printing with automatic formatting
  - Message prefix cleaning (removes "<-", "->", control characters)
  - Scrollable content with ↑↓, PgUp/PgDn, Home/End navigation
  - Word wrap toggle for long content
- **Visual focus indicators**: Clear indication of focused areas (proxy list vs logs) with keyboard hints
- **Statistics dashboard**: Real-time proxy statistics including requests, connections, and data transfer

#### Testing and Development
- **Comprehensive test framework**: Multiple test modes for demonstrating MCP communication flows
- **Demo scripts**: Interactive demonstrations of client ↔ proxy ↔ server communication
- **Test MCP server/client**: Simple implementations for testing proxy functionality
- **Unified CLI**: `mcp-trace` command with subcommands for different operations

#### User Experience
- **Keyboard navigation**: Intuitive keyboard controls with context-sensitive help
  - `←/→`: Switch focus between proxy list and logs
  - `↑/↓`: Navigate within focused area
  - `Enter`: Select proxy for filtering or view log details
  - `Esc`: Clear filters or exit navigation mode
  - `Tab/Shift+Tab`: Switch between log filter tabs
  - `W`: Toggle word wrap in detail view
- **Clean TUI interface**: No interference from logging output to terminal
- **Responsive layout**: Proper container boundaries and scrolling
- **Status indicators**: Visual feedback for proxy status, connection state, and navigation modes

#### Architecture
- **Rust workspace**: Multi-crate architecture with shared common library
- **Async/await**: Full tokio-based async implementation for non-blocking operations
- **Modular design**: Separate binaries for proxy and monitor with shared types
- **Error handling**: Robust error handling with anyhow for error propagation

### Technical Details

#### Components
- **mcp-proxy**: STDIO proxy binary with IPC communication
- **mcp-monitor**: TUI monitoring application with ratatui
- **mcp-common**: Shared types, IPC protocols, and utilities
- **mcp-trace**: Unified CLI for debugging and testing

#### Dependencies
- **Rust**: Modern Rust with tokio async runtime
- **Ratatui**: Terminal user interface framework
- **Crossterm**: Cross-platform terminal manipulation
- **Serde**: JSON serialization/deserialization
- **Clap**: Command-line argument parsing
- **UUID/Chrono**: Unique identifiers and timestamps

#### Communication Protocol
- **IPC Messages**: Structured message passing for proxy events
- **Log Levels**: Debug, Info, Warning, Error, Request, Response
- **Statistics**: Real-time metrics collection and reporting
- **Buffering**: Memory-efficient log management with automatic cleanup

### Configuration
- **CLI arguments**: Comprehensive command-line interface for both proxy and monitor
- **Environment variables**: Support for configuration via environment
- **Socket paths**: Configurable IPC socket locations
- **Verbose logging**: Optional detailed logging to files (avoiding TUI interference)

---

This release establishes the foundation for MCP (Model Context Protocol) proxy monitoring with a complete TUI interface, robust communication handling, and comprehensive testing framework.
