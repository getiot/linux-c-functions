.. Linux C Functions documentation master file, created by
   sphinx-quickstart on Mon Jun 14 17:07:40 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Linux 常用 C 函数参考手册
=============================================

这是一份开源的《Linux 常用 C 函数参考手册》中文版，你可以在 `GitHub <https://github.com/getiot/linux-c-functions>`_ 找到它并参与维护。文档托管在 `GetIoT.tech <https://getiot.tech>`_ 网站，示例代码均可在 `linux-c <https://github.com/getiot/linux-c>`_ 仓库找到。

.. raw:: html

   <div style="background: rgb(238, 237, 250); padding: 1.5rem; border-radius: 8px; margin: 1rem 0; border-left: 4px solid #6c5ce7;">
       <h3 style="margin-top: 0; color: #6c5ce7;">📚 关于本手册</h3>
       <p style="margin-bottom: 0.5rem; color: #333;">本手册收录了 Linux 系统中常用的 C 语言函数，涵盖 <strong>19 个分类</strong>，包括：</p>
       <ul style="margin-bottom: 0; color: #333;">
           <li><strong>基础功能</strong>：字符测试、字符串转换、内存管理、数学函数、时间处理、数据结构</li>
           <li><strong>系统编程</strong>：文件操作、进程管理、线程控制、信号处理、进程间通信</li>
           <li><strong>网络编程</strong>：网络接口、I/O 复用</li>
           <li><strong>其他特性</strong>：权限控制、用户组管理、环境变量、终端控制</li>
       </ul>
   </div>

.. raw:: html

   <div style="background: #e8f4fd; padding: 1.5rem; border-radius: 8px; margin: 1rem 0; border-left: 4px solid #2196f3;">
       <h3 style="margin-top: 0; color: #2196f3;">🎯 适用人群</h3>
       <p style="margin-bottom: 0; color: #333;">本手册适合 C 语言开发者、Linux 系统程序员、嵌入式开发者、系统管理员以及计算机科学专业学生使用。每个函数都提供了详细的参数说明、返回值解释、使用示例和编译运行指导。</p>
   </div>


.. raw:: html

   <br/>


📑 函数分类
=============================================

基础功能
---------------------------------------------

.. raw:: html

   <style>
   /* 统一的深色风格样式 */
   .function-card {
       display: block;
       padding: 1rem;
       background: #2d2d3a;
       border: 1px solid #4a4a5c;
       border-radius: 8px;
       text-decoration: none;
      ..  color: #a78bfa;
       text-align: center;
       font-weight: 500;
       transition: all 0.3s ease;
       box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }
   
   .function-card:hover {
      ..  background: #5a4fcf;
      ..  color: white;
       transform: translateY(-2px);
       box-shadow: 0 4px 8px rgba(0,0,0,0.2);
   }
   
   .info-card {
       padding: 2rem;
       border-radius: 8px;
       margin: 2rem 0;
       border-left: 4px solid #a78bfa;
       background: #1a1a24;
       color: #e0e0e0;
       box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }
   
   .info-card h2 {
       color: #a78bfa;
       margin-top: 0;
   }

   .info-card p {
       color: #e0e0e0;
   }
   
   .info-card a {
       color: #a78bfa;
       text-decoration: none;
   }
   
   .info-card a:hover {
       text-decoration: underline;
   }
   
   .support-section {
       text-align: center;
       margin: 3rem 0;
       padding: 2rem;
       background: #4a4fcf;
       color: white;
       border-radius: 8px;
       box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   }
   
   .support-section h2 {
       color: white;
       margin-top: 0;
   }

   .support-section p {
       color: #e0e0e0;
   }
   
   .support-section a {
       color: white;
       text-decoration: underline;
   }
   
   .support-section a:hover {
       text-decoration: none;
   }
   
   /* 统一的网格布局样式 */
   .function-grid {
       display: grid;
       grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
       gap: 1rem;
       margin: 1rem 0;
   }
   </style>
   
   <div class="function-grid">
       <a href="char.html" class="function-card">字符测试</a>
       <a href="string-convert.html" class="function-card">字符串转换</a>
       <a href="memory.html" class="function-card">内存控制</a>
       <a href="memory-string.html" class="function-card">内存字符串</a>
       <a href="math.html" class="function-card">数学函数</a>
       <a href="time.html" class="function-card">时间处理</a>
       <a href="data-structure.html" class="function-card">数据结构</a>
   </div>

系统编程
---------------------------------------------

.. raw:: html

   <div class="function-grid">
       <a href="file.html" class="function-card">文件操作</a>
       <a href="file-content.html" class="function-card">文件内容</a>
       <a href="process.html" class="function-card">进程操作</a>
       <a href="ipcs.html" class="function-card">进程通信</a>
       <a href="pthreads.html" class="function-card">线程管理</a>
       <a href="signal.html" class="function-card">信号处理</a>
   </div>

网络编程
---------------------------------------------

.. raw:: html

   <div class="function-grid">
       <a href="network.html" class="function-card">网络接口</a>
       <a href="io-multiplexing.html" class="function-card">I/O复用</a>
   </div>

其他特性
---------------------------------------------

.. raw:: html

   <div class="function-grid">
       <a href="permission.html" class="function-card">权限控制</a>
       <a href="user-group.html" class="function-card">用户组</a>
       <a href="env.html" class="function-card">环境变量</a>
       <a href="tty.html" class="function-card">终端控制</a>
   </div>

.. raw:: html

   <br/>
   <div class="info-card">
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

   <div class="support-section">
       <h2>🌟 支持我们</h2>
       <p style="font-size: 1.1em; margin-bottom: 1rem;">如果这份开源手册对你有帮助，请给我们一个 Star ⭐ <a href="https://github.com" target="_blank">GitHub</a></p>
       <p style="margin-bottom: 0;">访问 <a href="https://getiot.tech" target="_blank">GetIoT.tech</a> 了解更多物联网相关内容</p>
   </div>

.. toctree::
   :maxdepth: 1
   :caption: 目录

   基础功能
   ========
   
   char
   string-convert
   memory
   memory-string
   math
   time
   data-structure

   系统编程
   ========
   
   file
   file-content
   process
   ipcs
   pthreads
   signal

   网络编程
   ========
   
   network
   io-multiplexing

   其他特性
   ========
   
   permission
   user-group
   env
   tty
