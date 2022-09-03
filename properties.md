## burstradar

**Register**:
1)bytesRemaining(1)
2)index(1)
3)ring_buffer(MAX_ENTRIES)

**Properties**:
1)index<MAX_ENTRIES （需要合理处理clone E2E）

终止性不受影响，不过看起来bytesRemaining会受standard metadata中的队列长度字段影响，多次之后才会归零。



## capset

**Register:** 12个

**Properties**:
1)num_packets<NUM_PACKETS
在362行会判断这个值，但是仍然可能导致越界
2)不会出现intra_group_index<PACKETS_PER_GROUP且inter_index >= NUM_GROUPS
不变式形式类似

这个属性2可能是我们需要的，两个register之间有约束的情况。

1）简化如下

```
function {:existential true} b0(i:int): bool;

procedure main()
{
	var i: int;
	i := 0;
	while (true)
	invariant b0(i);
	{
		i := i + 1;
		if(i == 100){
			i := 0;
		}
		assert(i < 100);
	}
}
```



2）简化如下：

```
function {:existential true} b0(i:int, j:int): bool;

procedure main()
{
	var i: int, j: int;

	i := 0;
	j := 0;
	while (true)
	invariant b0(i, j);
	{
		i := i + 1;
		if(i >= 100){
			i := 0;
			j := j+1;
			if(j >= 10){
				j := 0;
			}
		}
		assert(i < 100 && j < 10);
	}
}
```



## Codel(unconfirmed)

**Register:**5个

**Properties**:

- r_drop_count和r_last_drop_count可能存在大小关系
- r_state_dropping可能影响更新其他register的值



## P4Entropy(unconfirmed)

**Register：**8个

**Properties**：

- queryResult和另外几个register1-4可能存在大小关系



## ddosmitigation

**Register: **63个

**Properties:**

- pkt_counter[0] < (1<<log2_m[0])
  典型情况：出现了对“variable != constant"的判断，无法正确验证variable的范围。因为一旦初始为>，那么后面将一直是大于。
- 假定初始情况下，src_S[0]==dst_S[0]，且每次的meta.entropy_term相等，那么src_S[0]和dst_S[0]始终相等
  由于havoc之后，这个相等关系可能就没有了，在后续也不会保持



## INVEST

**Register:**2个

**Properties：**

- 假定初始值下，hll_register[0]<meta.value（这里认为是常量），执行完毕后，hll_register[0]<=meta.value
  在havoc的情况下无法保证这个关系一定成立



## cheetah-p4

**Register：**7个

**Properties：**

- bucket_counter[0] <= BUCKET_SIZE
  同样，如果havoc出现了大于的情况，那么不会清零，不满足
- push_index[0] <= 10+offset
  类似
- pop_index同上





## 典型情况总结

典型情况应该是：
~~1）如果某个register的值会通过分支条件影响另外一个register的取值，那么它们之间存在约束关系。如：~~
~~``` if(reg1==c1) reg2==c2```~~
~~但是这种似乎使用传统方法也可以解决掉，因为只是assume了一种情况~~

如果在循环头不满足，那么在循环结束后必定不满足的属性，才可以作为我们想要的循环不变式。
（前面的例子里，如果`reg1==c1 && reg2 != c2`在初始为真，在出口为假，因为reg2必定会被更新）

新想法：

- **assertion未必要在程序出口，可以在循环体的任何位置，不需要是不变式**
- register的大小可以纳入不变式的考虑范围

**在ICE测例中的典型情况**

- 多个全局变量的计算之间有依赖关系（一个全局变量的计算依赖另外一个全局变量的值）
- 某个全局变量和循环条件有关系（这个是我们做不到的）
- 有的带全称量词（array_diff.bpl）
- 有的是两个全局变量的和满足某种关系（如：a+b=3*n）
- 可能是多个子式的与或非
- count_by_1可以参考
- 循环条件是某个值，assertion写另一个值

while(*)不确定是什么意思



- 不能从技术去考虑能做什么问题，要考虑什么问题是有价值的，再去改进技术
- 最好是已有协议涉及到了某些assertion，这些assertion中可能没有register变量，但是他们间接地涉及到register的判断

之前是假定用户可能存在某些属性直接涉及到register，但是找不到例子，可能是因为要求太强太局限了
