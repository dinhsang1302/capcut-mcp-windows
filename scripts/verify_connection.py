"""Test the installed stdio MCP handshake and call capcut_probe only."""
import asyncio
import json
from pathlib import Path
import sys
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


async def check():
    executable = Path(sys.executable).with_name('capcut-mcp.exe')
    if not executable.is_file():
        raise FileNotFoundError(executable)
    async with stdio_client(StdioServerParameters(command=str(executable))) as streams:
        async with ClientSession(*streams) as session:
            await session.initialize()
            tools = await session.list_tools()
            assert any(tool.name == 'capcut_probe' for tool in tools.tools)
            print(f'MCP handshake OK; {len(tools.tools)} tools registered.')
            result = await session.call_tool('capcut_probe', {})
            if result.is_error:
                raise RuntimeError(result)
            for content in result.content:
                if content.type == 'text':
                    # Local output can include paths; never commit this output.
                    print(content.text)
            print('Probe completed. No editing or saving tool was called.')


if __name__ == '__main__':
    asyncio.run(asyncio.wait_for(check(), timeout=90))
