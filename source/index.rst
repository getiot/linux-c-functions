.. Linux C Functions documentation master file, created by
   sphinx-quickstart on Mon Jun 14 17:07:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Linux 常用 C 函数参考手册
=============================================

这是一份开源的《Linux 常用 C 函数参考手册》中文版，你可以在 `GitHub <https://github.com/getiot/linux-c-functions>`_ 找到它并参与维护。文档托管在 `GetIoT.tech <https://getiot.tech>`_ 网站，示例代码均可在 `linux-c <https://github.com/getiot/linux-c>`_ 仓库找到。


.. raw:: html

   <br/>


函数分类
=============================================

基础功能
---------------------------------------------

.. raw:: html

   <style>
   .function-card {
       display: block;
       padding: 1rem;
       background: #f8f9ff;
       border: 1px solid #e0e6ff;
       border-radius: 8px;
       text-decoration: none;
       color: #6c5ce7;
       text-align: center;
       font-weight: 500;
       transition: all 0.3s ease;
   }
   
   .function-card:hover {
       color: white;
       transform: translateY(-2px);
   }
   
   @media (prefers-color-scheme: dark) {
       .function-card {
           background: #2d2d3a;
           border-color: #4a4a5c;
           color: #a78bfa;
       }
       
       .function-card:hover {
           color: white;
       }
   }
   </style>
   
   <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">
       <a href="char.html" class="function-card">字符测试</a>
       <a href="string-convert.html" class="function-card">字符串转换</a>
       <a href="memory.html" class="function-card">内存控制</a>
       <a href="memory-string.html" class="function-card">内存字符串</a>
       <a href="math.html" class="function-card">数学函数</a>
       <a href="data-structure.html" class="function-card">数据结构</a>
   </div>

系统编程
---------------------------------------------

.. raw:: html

   <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">
       <a href="file.html" class="function-card">文件操作</a>
       <a href="file-content.html" class="function-card">文件内容</a>
       <a href="process.html" class="function-card">进程操作</a>
       <a href="signal.html" class="function-card">信号处理</a>
       <a href="permission.html" class="function-card">权限控制</a>
   </div>

网络与通信
---------------------------------------------

.. raw:: html

   <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">
       <a href="network.html" class="function-card">网络接口</a>
       <a href="io-multiplexing.html" class="function-card">I/O复用</a>
       <a href="ipcs.html" class="function-card">进程通信</a>
   </div>

高级特性
---------------------------------------------

.. raw:: html

   <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">
       <a href="pthreads.html" class="function-card">线程管理</a>
       <a href="time.html" class="function-card">时间处理</a>
       <a href="user-group.html" class="function-card">用户组</a>
       <a href="env.html" class="function-card">环境变量</a>
       <a href="tty.html" class="function-card">终端控制</a>
   </div>

.. raw:: html

   <style>
   .info-card {
       padding: 2rem;
       border-radius: 8px;
       margin: 2rem 0;
       border-left: 4px solid #6c5ce7;
   }
   
   .info-card-light {
       background: #f8f9ff;
   }
   
   .info-card-dark {
       background: #2d2d3a;
   }
   
   .info-card h2 {
       color: #6c5ce7;
       margin-top: 0;
   }
   
   .info-card a {
       color: #6c5ce7;
   }
   
   @media (prefers-color-scheme: dark) {
       .info-card-light {
           background: #2d2d3a;
       }
       
       .info-card-dark {
           background: #1a1a24;
       }
       
       .info-card h2 {
           color: #a78bfa;
       }
       
       .info-card a {
           color: #a78bfa;
       }
   }
   </style>

.. raw:: html

   <br/>
   <div class="info-card info-card-light">
       <h2>📝 参与贡献</h2>
       <p>本手册是开源项目，欢迎大家一起完善！你可以：</p>
       <ul>
           <li>修正文档中的错误</li>
           <li>添加缺失的函数说明</li>
           <li>改进示例代码</li>
           <li>补充现代 Linux 特性</li>
       </ul>
       <p>项目地址：<a href="https://github.com/getiot/linux-c-functions" target="_blank">GitHub</a> | 示例代码：<a href="https://github.com/getiot/linux-c" target="_blank">linux-c</a></p>
   </div>


.. raw:: html

   <style>
   .support-section {
       text-align: center;
       margin: 3rem 0;
       padding: 2rem;
       background: #6c5ce7;
       color: white;
       border-radius: 8px;
   }
   
   .support-section h2 {
       color: white;
       margin-top: 0;
   }
   
   .support-section a {
       color: white;
       text-decoration: underline;
   }
   
   @media (prefers-color-scheme: dark) {
       .support-section {
           background: #5a4fcf;
       }
   }
   </style>
   
   <div class="support-section">
       <h2>🌟 支持我们</h2>
       <p style="font-size: 1.1em; margin-bottom: 1rem;">如果这份开源手册对你有帮助，请给我们一个 Star ⭐ <a href="https://github.com" target="_blank">GitHub</a></p>
       <p style="margin-bottom: 0;">访问 <a href="https://getiot.tech" target="_blank">GetIoT.tech</a> 了解更多物联网相关内容</p>
   </div>
