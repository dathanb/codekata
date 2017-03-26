module BinarySearch
  class Iterative
    attr_reader :nums

    def initialize(nums)
      @nums = [*nums]
    end

    def find(n)
      lower = 0
      upper = nums.count

      while upper != lower
        pivot = (upper + lower)/2
        pivot_value = nums[pivot]

        if n > pivot_value
          # Because dividing by two to establish the new pivot rounds down, when we get to very small partitions,
          # without this + 1, we'll frequently encounter an infinite loop when comparing n against the pivot value
          lower = pivot + 1
        elsif n < pivot_value
          upper = pivot
        else
          return pivot
        end
      end

      nums[upper] == n ? upper : nil
    end
  end

  class Recursive
    attr_reader :nums

    def initialize(nums)
      @nums = nums
    end

    def find(n)
      inner_find(0, nums.count - 1, n)
    end

    def inner_find(lower, upper, n)
      if upper == lower
        return nums[upper] == n ? upper : nil
      end

      pivot = (upper + lower)/2
      pivot_value = nums[pivot]

      if n > pivot_value
        return inner_find(pivot + 1, upper, n)
      elsif n < pivot_value
        return inner_find(lower, pivot, n)
      else
        return pivot
      end
    end
  end

  class Reductive
    attr_reader :nums

    def initialize(nums)
      @nums = nums
    end

    def find(n)
      index, _ = nums.reduce([0, nums.count-1]) do |a, e|
        lower, upper = a
        pivot = (upper + lower)/2
        pivot_value = nums[pivot]
        if n > pivot_value
          next [pivot+1, upper]
        elsif n < pivot_value
          next [lower, pivot]
        else
          break [pivot, pivot]
        end
      end

      return nums[index] == n ? index : nil
    end
  end

  class VirtualTreeNode
    attr_accessor :nums, :index

    def initialize(index, nums, lower, upper)
      @index = index
      @nums = nums
      @lower = lower
      @upper = upper
    end

    def value
      nums[index]
    end

    def left
      new_index = (@lower + index) /2
      new_index == index ? nil : VirtualTreeNode.new(new_index, nums, @lower, index)
    end

    def right
      new_index = (index + 1 + @upper) /2
      new_index == index ? nil: VirtualTreeNode.new(new_index, nums, index+1, @upper)
    end
  end

  class VirtualTreeIterative
    attr_reader :nums

    def initialize(nums)
      @nums = nums
    end

    def find(n)
      pivot = nums.length / 2
      pivot_node = VirtualTreeNode.new pivot, nums, 0, nums.length - 1
      while pivot_node && pivot_node.value != n
        if pivot_node.value > n
          pivot_node = pivot_node.left
        elsif pivot_node.value < n
          pivot_node = pivot_node.right
        end
      end

      pivot_node && pivot_node.index
    end
  end

  class VirtualTreeRecursive
    attr_reader :nums
    def initialize(nums)
      @nums = nums
    end

    def find(n)
      _find n, VirtualTreeNode.new(nums.count / 2, nums, 0, nums.count - 1)
    end

    def _find(n, node)
      return nil if node.nil?
      return node.index if n == node.value

      if n < node.value
        _find n, node.left
      elsif n > node.value
        _find n, node.right
      end
    end
  end
end

nums = (0..10).map(&:to_i)
[
  BinarySearch::Iterative,
  BinarySearch::Recursive,
  BinarySearch::Reductive,
  BinarySearch::VirtualTreeIterative,
  BinarySearch::VirtualTreeRecursive
].each do |cl|
  searcher = cl.new nums
  nums.each do |n|
    position = searcher.find(n)
    raise "Expected #{n}, got #{position.to_s}" unless position == n
    position = searcher.find(n + 0.5)
    raise "Expected nil, got #{position}" unless position.nil?
  end
end